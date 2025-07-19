# Check-In Domain Structure Analysis
## Recommended TypeScript Architecture for Next.js Port

### Executive Summary
You're correct - attempting to recreate models without exact field mapping would break compatibility between Flutter and Next.js versions. This analysis focuses on the **recommended TypeScript domain structure** and architectural patterns that will support your dual-platform approach while maintaining data consistency.

---

## 1. Recommended TypeScript Domain Structure

```typescript
src/
├── domain/
│   ├── entities/              # Core business entities (1:1 Flutter mapping)
│   │   ├── user/
│   │   ├── activity/
│   │   ├── reservation/
│   │   ├── listing/
│   │   └── attendee/
│   ├── enums/                 # Domain enums (exact Flutter equivalents)
│   │   ├── user-enums.ts
│   │   ├── activity-enums.ts
│   │   ├── payment-enums.ts
│   │   └── common-enums.ts
│   ├── value-objects/         # Immutable domain primitives
│   │   ├── identifiers/       # UniqueId, Email, Phone, etc.
│   │   ├── address/           # Address, Location, Coordinates
│   │   ├── money/             # Currency, Price, PricingBreakdown
│   │   └── time/              # TimeSlot, DateRange, Availability
│   ├── aggregates/            # Business logic boundaries
│   │   ├── activity-aggregate.ts
│   │   ├── reservation-aggregate.ts
│   │   └── user-aggregate.ts
│   ├── services/              # Domain services (business logic)
│   │   ├── pricing-service.ts
│   │   ├── availability-service.ts
│   │   └── notification-service.ts
│   └── events/                # Domain events
│       ├── activity-events.ts
│       ├── reservation-events.ts
│       └── user-events.ts
├── types/                     # TypeScript type definitions
│   ├── api/                   # API request/response types
│   ├── database/              # Database schema types
│   └── shared/                # Shared utility types
└── schemas/                   # Validation schemas (Zod)
    ├── validators/            # Common validators
    │   ├── email-validator.ts
    │   ├── password-validator.ts
    │   ├── address-validator.ts
    │   └── phone-validator.ts
    ├── entities/              # Entity validation schemas
    └── api/                   # API validation schemas
```

---

## 2. Understanding Domain Aggregates

### What are Aggregates?
Aggregates are **consistency boundaries** in Domain-Driven Design. They group related entities and value objects that must change together to maintain business invariants.

### Key Principles:
1. **Consistency Boundary**: All changes within an aggregate are consistent
2. **Transactional Boundary**: Aggregate changes happen in a single transaction
3. **Single Root**: Only the aggregate root can be referenced from outside
4. **Business Invariants**: Aggregates enforce business rules

### Example: Activity Aggregate
```typescript
// Activity Aggregate Root
class ActivityAggregate {
  private constructor(
    private activity: Activity,           // Root entity
    private timeSlots: TimeSlot[],       // Child entities
    private attendees: Attendee[],       // Child entities
    private pricing: PricingModel        // Value object
  ) {}

  // Factory method - ensures valid creation
  static create(data: CreateActivityData): ActivityAggregate {
    // Business rule: Activity must have at least one time slot
    if (!data.timeSlots || data.timeSlots.length === 0) {
      throw new Error('Activity must have at least one time slot');
    }
    
    // Business rule: Pricing must be valid for activity type
    const pricing = PricingModel.create(data.pricing, data.activityType);
    
    return new ActivityAggregate(
      Activity.create(data),
      data.timeSlots.map(slot => TimeSlot.create(slot)),
      [],
      pricing
    );
  }

  // Business method - enforces invariants
  addAttendee(attendeeData: AddAttendeeData): void {
    // Business rule: Cannot exceed capacity
    const totalCapacity = this.timeSlots.reduce((sum, slot) => sum + slot.capacity, 0);
    if (this.attendees.length >= totalCapacity) {
      throw new Error('Activity is at full capacity');
    }

    // Business rule: Payment required for paid activities
    if (this.pricing.requiresPayment && !attendeeData.paymentInfo) {
      throw new Error('Payment information required');
    }

    const attendee = Attendee.create(attendeeData, this.activity.id);
    this.attendees.push(attendee);

    // Domain event
    this.raiseDomainEvent(new AttendeeAddedEvent(this.activity.id, attendee.id));
  }

  // Read-only access to internal state
  getActivity(): Activity {
    return this.activity;
  }

  getAttendees(): readonly Attendee[] {
    return Object.freeze([...this.attendees]);
  }
}
```

### Why Aggregates Matter for Your Port:
1. **Business Logic Consistency**: Ensures Flutter and Next.js versions follow same rules
2. **Data Integrity**: Prevents invalid states across both platforms
3. **Clear Boundaries**: Defines what changes together
4. **Simplified Testing**: Business logic is contained and testable

---

## 3. Value Objects Structure

### Core Value Objects You'll Need:
```typescript
// Identifiers
export class UniqueId {
  private constructor(private readonly value: string) {}
  
  static create(value?: string): UniqueId {
    const id = value || crypto.randomUUID();
    if (!this.isValid(id)) throw new Error('Invalid UUID');
    return new UniqueId(id);
  }
  
  toString(): string { return this.value; }
  equals(other: UniqueId): boolean { return this.value === other.value; }
  
  private static isValid(value: string): boolean {
    return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value);
  }
}

// Email with validation
export class Email {
  private constructor(private readonly value: string) {}
  
  static create(value: string): Email {
    if (!this.isValid(value)) throw new Error('Invalid email format');
    return new Email(value.toLowerCase().trim());
  }
  
  toString(): string { return this.value; }
  
  private static isValid(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}

// Money/Currency handling
export class Money {
  private constructor(
    private readonly amount: number,
    private readonly currency: string
  ) {}
  
  static create(amount: number, currency: string = 'USD'): Money {
    if (amount < 0) throw new Error('Amount cannot be negative');
    if (!this.isValidCurrency(currency)) throw new Error('Invalid currency');
    return new Money(Math.round(amount * 100) / 100, currency); // Round to 2 decimals
  }
  
  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('Cannot add different currencies');
    }
    return Money.create(this.amount + other.amount, this.currency);
  }
  
  getAmount(): number { return this.amount; }
  getCurrency(): string { return this.currency; }
  
  private static isValidCurrency(currency: string): boolean {
    return ['USD', 'EUR', 'GBP', 'CAD'].includes(currency);
  }
}
```

---

## 4. Essential Validation Schemas

### Core Validators
```typescript
// Email Validator
export const emailValidator = z.string()
  .email('Invalid email format')
  .min(5, 'Email too short')
  .max(254, 'Email too long')
  .transform(email => email.toLowerCase().trim());

// Password Validator
export const passwordValidator = z.string()
  .min(8, 'Password must be at least 8 characters')
  .max(128, 'Password too long')
  .regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, 
    'Password must contain uppercase, lowercase, and number');

// Phone Validator
export const phoneValidator = z.string()
  .regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone number format')
  .optional();

// Address Validator
export const addressValidator = z.object({
  street: z.string().min(1, 'Street address required').max(200),
  city: z.string().min(1, 'City required').max(100),
  state: z.string().min(2, 'State required').max(50),
  zipCode: z.string().regex(/^\d{5}(-\d{4})?$/, 'Invalid zip code'),
  country: z.string().length(2, 'Country code must be 2 characters'),
  coordinates: z.object({
    latitude: z.number().min(-90).max(90),
    longitude: z.number().min(-180).max(180)
  }).optional()
});

// Currency/Money Validator
export const moneyValidator = z.object({
  amount: z.number().min(0, 'Amount cannot be negative'),
  currency: z.enum(['USD', 'EUR', 'GBP', 'CAD'])
});

// Date Range Validator
export const dateRangeValidator = z.object({
  start: z.date(),
  end: z.date()
}).refine(data => data.end > data.start, {
  message: 'End date must be after start date',
  path: ['end']
});
```

### Advanced Validation Patterns
```typescript
// Cross-field validation example
export const reservationValidator = z.object({
  activityId: z.string().uuid(),
  userId: z.string().uuid(),
  timeSlots: z.array(z.string().uuid()).min(1),
  paymentInfo: z.object({
    method: z.enum(['card', 'bank', 'digital_wallet']),
    amount: moneyValidator
  }).optional()
}).refine(data => {
  // Business rule: Payment required for paid activities
  // This would need activity data to validate properly
  return true; // Simplified for example
}, {
  message: 'Payment information required for paid activities'
});

// Conditional validation
export const attendeeValidator = z.discriminatedUnion('type', [
  z.object({
    type: z.literal('free'),
    userId: z.string().uuid(),
    activityId: z.string().uuid()
  }),
  z.object({
    type: z.literal('paid'),
    userId: z.string().uuid(),
    activityId: z.string().uuid(),
    paymentInfo: z.object({
      paymentIntentId: z.string(),
      amount: moneyValidator
    })
  }),
  z.object({
    type: z.literal('vendor'),
    userId: z.string().uuid(),
    activityId: z.string().uuid(),
    vendorProfile: z.object({
      businessName: z.string().min(1),
      category: z.enum(['food', 'crafts', 'services', 'other'])
    })
  })
]);
```

---

## 5. Services Layer Structure

### Domain Services (Business Logic)
```typescript
// Pricing calculation service
export class PricingService {
  calculateTotalPrice(
    basePrice: Money,
    taxes: Money,
    fees: Money[],
    discounts: Money[]
  ): Money {
    let total = basePrice.add(taxes);
    
    // Add fees
    fees.forEach(fee => {
      total = total.add(fee);
    });
    
    // Apply discounts
    discounts.forEach(discount => {
      total = total.subtract(discount);
    });
    
    return total;
  }
  
  calculateTaxes(basePrice: Money, taxRate: number, location: Address): Money {
    // Tax calculation logic based on location
    const taxAmount = basePrice.getAmount() * taxRate;
    return Money.create(taxAmount, basePrice.getCurrency());
  }
}

// Availability checking service
export class AvailabilityService {
  checkSlotAvailability(
    timeSlot: TimeSlot,
    existingReservations: Reservation[]
  ): boolean {
    const conflictingReservations = existingReservations.filter(reservation =>
      this.timeSlotsOverlap(timeSlot, reservation.timeSlots)
    );
    
    return conflictingReservations.length === 0;
  }
  
  private timeSlotsOverlap(slot1: TimeSlot, slots2: TimeSlot[]): boolean {
    return slots2.some(slot2 =>
      slot1.start < slot2.end && slot1.end > slot2.start
    );
  }
}
```

---

## 6. Compatibility Strategy with Flutter

### Exact Model Mapping
```typescript
// Instead of redefining models, create transformation layers
export interface FlutterToTypescriptMapper<T, U> {
  fromFlutter(flutterModel: T): U;
  toFlutter(typescriptModel: U): T;
}

// Example mapper for user profile
export class UserProfileMapper implements FlutterToTypescriptMapper<any, UserProfile> {
  fromFlutter(flutterModel: any): UserProfile {
    return {
      id: flutterModel.userId.value,
      legalName: flutterModel.legalName.value,
      legalSurname: flutterModel.legalSurname?.value, // Include all Flutter fields
      email: flutterModel.emailAddress.value,
      phone: flutterModel.phoneNumber?.value,
      // ... map all fields exactly
    };
  }
  
  toFlutter(typescriptModel: UserProfile): any {
    return {
      userId: { value: typescriptModel.id },
      legalName: { value: typescriptModel.legalName },
      legalSurname: typescriptModel.legalSurname ? { value: typescriptModel.legalSurname } : null,
      emailAddress: { value: typescriptModel.email },
      // ... reverse mapping
    };
  }
}
```

### API Compatibility Layer
```typescript
// Ensure API responses work for both platforms
export interface ApiResponse<T> {
  data: T;
  meta: {
    timestamp: string;
    version: string;
    platform: 'flutter' | 'nextjs';
  };
}

export function createCompatibleResponse<T>(
  data: T,
  platform: 'flutter' | 'nextjs'
): ApiResponse<T> {
  return {
    data: platform === 'flutter' ? mapToFlutterFormat(data) : data,
    meta: {
      timestamp: new Date().toISOString(),
      version: '1.0.0',
      platform
    }
  };
}
```

---

## 7. Next Steps & Recommendations

### Immediate Actions:
1. **Audit Flutter Models**: Extract exact field definitions from Flutter domain models
2. **Create Type Definitions**: Build 1:1 TypeScript interfaces matching Flutter models
3. **Implement Value Objects**: Start with UniqueId, Email, Money value objects
4. **Setup Validation**: Implement core validators (email, password, address)
5. **Define Aggregates**: Identify business boundaries for Activity, User, Reservation

### Architecture Decisions:
1. **Keep Models Identical**: Use transformation layers instead of redefining
2. **Shared Validation**: Centralize business rules in aggregates/services
3. **Event-Driven**: Use domain events for cross-aggregate communication
4. **Type Safety**: Leverage TypeScript for compile-time validation
5. **Runtime Safety**: Use Zod for API boundary validation

This approach ensures your Next.js port maintains perfect compatibility with the Flutter version while leveraging TypeScript's strengths for type safety and developer experience.

---

Would you like to proceed with analyzing the `check_in_application` state management layer next, or dive deeper into any specific aspect of this domain structure?