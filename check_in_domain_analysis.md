# Check-In Domain Package Analysis
## Shared Models and Enums for Next.js Port

### Executive Summary
The `check_in_domain` package serves as the foundational data layer for the dual-sided marketplace platform. This domain-driven design implementation contains comprehensive models, enums, and value objects that define the business logic and data structures across the entire application. The analysis reveals a sophisticated domain model with 8 major bounded contexts and 40+ core entities.

---

## 1. Domain Architecture Overview

### Current Domain Structure (Flutter/Dart)
```
check_in_domain/
├── domain/
│   ├── auth/                      # Authentication & User Management
│   │   ├── user_profile/          # User profile models
│   │   └── reservation_manager/   # Reservation management
│   ├── misc/                      # Shared domain services
│   │   ├── attendee_services/     # Attendee management
│   │   ├── explore_services/      # Discovery & search
│   │   ├── messages_services/     # Messaging & communication
│   │   ├── stripe/               # Payment processing
│   │   ├── filter_services/      # Filtering & sorting
│   │   └── discount_code_service/ # Promotions
│   └── value_objects/            # Domain value objects
```

### Target Domain Structure (Next.js/TypeScript)
```typescript
// Recommended TypeScript domain structure
src/
├── domain/
│   ├── entities/              # Core business entities
│   ├── enums/                 # Domain enums
│   ├── value-objects/         # Value objects and primitives
│   ├── aggregates/            # Domain aggregates
│   └── services/              # Domain services
├── types/                     # TypeScript type definitions
└── schemas/                   # Validation schemas (Zod)
```

---

## 2. Flutter to TypeScript Model Port Process

### Overview
This section outlines the **exact process** for porting Flutter domain models from `stefanmiller/check_in_domain` to TypeScript while maintaining 100% field compatibility and Firebase JSON structure compatibility.

### 🔒 **Port Process Rules**
1. **Source**: All backend models live in `stefanmiller/check_in_domain`
2. **Naming**: Do NOT change the naming of any existing models
3. **Fields**: Capture every single value within the model
4. **Structure**: Create sub-models contained within the primary model
5. **Storage**: Firebase-friendly JSON structure
6. **Verification**: TS compatibility check with Firebase and existing Flutter model

---

### Step-by-Step Model Port Process

#### Step 1: Locate Source Model
```bash
# Example source location
stefanmiller/check_in_domain/lib/domain/auth/profile_services/profile/user/user_profile_item.dart
```

#### Step 2: Analyze Flutter Model Structure
Extract the exact field structure from the Flutter domain model:

```dart
// Flutter Source (check_in_domain)
class UserProfileModel {
  final UserId userId;
  final LegalName legalName;
  final LegalSurname? legalSurname;
  final EmailAddress emailAddress;
  final PhoneNumber? phoneNumber;
  final ProfileImageUrl? profileImageUrl;
  final DateOfBirth? dateOfBirth;
  
  // Sub-models
  final Address? address;
  final List<SocialMediaProfile> socialMediaProfiles;
  final AccountSettings accountSettings;
  final PrivacySettings privacySettings;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

#### Step 2.1: Analyze Flutter Value Object Validators (Optional)
Check for existing validators in Flutter value objects:

```bash
# Check for validators in value objects
stefanmiller/check_in_domain/lib/domain/auth/profile_services/profile/value_objects.dart
```

Example Flutter validators to extract:
```dart
// Flutter value object validators
class EmailAddress {
  static Either<ValueFailure<String>, EmailAddress> create(String input) {
    return validateEmailAddress(input).fold(
      (failure) => left(failure),
      (validEmail) => right(EmailAddress._(validEmail)),
    );
  }
}

class LegalName {
  static Either<ValueFailure<String>, LegalName> create(String input) {
    return validateStringNotEmpty(input)
        .flatMap((a) => validateSingleLine(a))
        .flatMap((a) => validateMaxLength(a, 100))
        .fold(
          (failure) => left(failure),
          (validName) => right(LegalName._(validName)),
        );
  }
}
```

#### Step 3: Identify Value Objects vs Simple Fields
Map Flutter value objects to TypeScript simple types:

```typescript
// Flutter Value Object → TypeScript Simple Type
UserId userId               → string userId
LegalName legalName         → string legalName  
LegalSurname? legalSurname  → string? legalSurname
EmailAddress emailAddress  → string emailAddress
PhoneNumber? phoneNumber    → string? phoneNumber
DateTime createdAt          → Date createdAt (JavaScript Date object)
```

#### Step 4: Create TypeScript Interface (Exact Naming)
```typescript
// src/domain/entities/user-profile.entity.ts
export interface UserProfileModel {  // ✅ EXACT name from Flutter
  // Primary fields (exact field names)
  userId: string;                     // UserId.getOrCrash() → string
  legalName: string;                  // LegalName.getOrCrash() → string
  legalSurname?: string;              // LegalSurname?.value.fold() → optional string
  emailAddress: string;               // EmailAddress.getOrCrash() → string
  phoneNumber?: string;               // PhoneNumber?.value → optional string
  profileImageUrl?: string;           // ProfileImageUrl?.value → optional string
  dateOfBirth?: Date;                 // DateOfBirth? → optional Date object
  
  // Sub-models (nested objects - exact names)
  address?: Address;                  // Address? → optional nested object
  socialMediaProfiles: SocialMediaProfile[];  // List<SocialMediaProfile> → array
  accountSettings: AccountSettings;   // AccountSettings → nested object
  privacySettings: PrivacySettings;   // PrivacySettings → nested object
  
  // Metadata (Firebase compatible)
  createdAt: Date;                    // DateTime → Date object
  updatedAt: Date;                    // DateTime → Date object
}
```

#### Step 5: Create Sub-Models (Exact Structure)
```typescript
// Sub-model: Address (maintain exact Flutter structure)
export interface Address {
  street: string;                     // From Flutter Address model
  city: string;
  state: string;
  zipCode: string;
  country: string;
  coordinates?: {                     // Optional nested coordinate object
    latitude: number;
    longitude: number;
  };
}
```

#### Step 6: Firebase Date Handling Strategy

Firebase can store dates in multiple formats. We'll use **Timestamp** for optimal compatibility:

```typescript
// Firebase storage formats
// Option 1: Firestore Timestamp (RECOMMENDED)
import { Timestamp } from 'firebase/firestore';

// Date conversion utilities
export class DateConverter {
  // Convert Firebase Timestamp to JavaScript Date
  static timestampToDate(timestamp: Timestamp | string | Date): Date {
    if (timestamp instanceof Date) return timestamp;
    if (timestamp instanceof Timestamp) return timestamp.toDate();
    if (typeof timestamp === 'string') return new Date(timestamp);
    throw new Error('Invalid timestamp format');
  }
  
  // Convert JavaScript Date to Flutter-compatible ISO string
  static dateToFlutterDateTime(date: Date): string {
    return date.toISOString();
  }
}
```

#### Step 7: Map Flutter Validators to Zod (Optional)
If Flutter value objects have validators, extract and map them to Zod:

```typescript
// Flutter Validator → Zod Equivalent Mapping
const FlutterToZodMapping = {
  validateStringNotEmpty: (field: string) => z.string().min(1, `${field} cannot be empty`),
  validateSingleLine: (field: string) => z.string().regex(/^[^\n\r]*$/, `${field} must be single line`),
  validateMaxLength: (field: string, max: number) => z.string().max(max, `${field} cannot exceed ${max} characters`),
  validateEmailAddress: (field: string) => z.string().email(`Invalid ${field} format`),
};
```

#### Step 8: Create Zod Validation Schema
Apply Flutter validator mappings to create comprehensive Zod schema:

```typescript
// src/domain/schemas/user-profile.schema.ts
import { z } from 'zod';

export const UserProfileModelSchema = z.object({
  userId: z.string().uuid(),
  
  // LegalName validators: validateStringNotEmpty + validateSingleLine + validateMaxLength(100)
  legalName: z.string()
    .min(1, "Legal name cannot be empty")
    .max(100, "Legal name cannot exceed 100 characters")
    .regex(/^[^\n\r]*$/, "Legal name must be single line"),
  
  // EmailAddress validators: validateEmailAddress
  emailAddress: z.string()
    .email("Invalid email address format"),
  
  phoneNumber: z.string().optional(),
  profileImageUrl: z.string().url().optional(),
  dateOfBirth: z.date().optional(),
  
  // Sub-models and metadata
  address: AddressSchema.optional(),
  socialMediaProfiles: z.array(SocialMediaProfileSchema),
  accountSettings: AccountSettingsSchema,
  privacySettings: PrivacySettingsSchema,
  createdAt: z.date(),
  updatedAt: z.date(),
});

export type UserProfileModel = z.infer<typeof UserProfileModelSchema>;
```

---

### Flutter to TypeScript Enum Port Process

#### Enum Step 1: Locate Source Enum
```bash
# Example enum source location
stefanmiller/check_in_domain/lib/domain/attendee_services/attendee/attendee_type.dart
```

#### Enum Step 2: Analyze Flutter Enum Structure
Extract the exact enum values from Flutter:

```dart
// Flutter Source (check_in_domain)
enum AttendeeType {
  free,
  tickets,
  pass,
  vendor,
  instructor,
  partner,
  organization,
  interested
}
```

#### Enum Step 3: Create TypeScript String Literal Union (Exact Naming)
```typescript
// src/domain/enums/attendee.enums.ts
export type AttendeeType = 
  | 'free'                    // AttendeeType.free → 'free'
  | 'tickets'                 // AttendeeType.tickets → 'tickets'
  | 'pass'                    // AttendeeType.pass → 'pass'
  | 'vendor'                  // AttendeeType.vendor → 'vendor'
  | 'instructor'              // AttendeeType.instructor → 'instructor'
  | 'partner'                 // AttendeeType.partner → 'partner'
  | 'organization'            // AttendeeType.organization → 'organization'
  | 'interested';             // AttendeeType.interested → 'interested'

// Optional: Create constants object for easy access
export const AttendeeTypeValues = {
  FREE: 'free' as const,
  TICKETS: 'tickets' as const,
  PASS: 'pass' as const,
  VENDOR: 'vendor' as const,
  INSTRUCTOR: 'instructor' as const,
  PARTNER: 'partner' as const,
  ORGANIZATION: 'organization' as const,
  INTERESTED: 'interested' as const,
} as const;
```

#### Enum Step 4: Zod Enum Validation
```typescript
// src/domain/schemas/attendee.schema.ts
import { z } from 'zod';

export const AttendeeTypeSchema = z.enum([
  'free',
  'tickets', 
  'pass',
  'vendor',
  'instructor',
  'partner',
  'organization',
  'interested'
]);

// Use in larger schemas
export const AttendeeItemSchema = z.object({
  attendeeId: z.string().uuid(),
  attendeeType: AttendeeTypeSchema,  // Validates against exact Flutter enum values
  // ... other fields
});
```

#### Enum Step 5: Firebase Compatibility Check
```typescript
// Verify enum values work with Firebase
const attendeeData = {
  attendeeId: "uuid-string",
  attendeeType: "vendor" as AttendeeType,  // Stored as string in Firebase
  // ...
};

// Firebase stores: { attendeeType: "vendor" }
// Flutter reads: AttendeeType.vendor
// TypeScript reads: "vendor" as AttendeeType
```

### Verification Checklist

#### ✅ **Model Structure Verification**
- [ ] Exact model name preserved (`UserProfileModel`)
- [ ] Every Flutter field captured in TypeScript
- [ ] Sub-models created for nested objects
- [ ] Optional fields properly marked with `?`
- [ ] Array types correctly mapped from `List<T>`

#### ✅ **Type Mapping Verification**
- [ ] Flutter value objects → TypeScript simple types
- [ ] `DateTime` → JavaScript `Date` object
- [ ] `bool` → `boolean`
- [ ] Enums → string literals
- [ ] Optional types properly handled

#### ✅ **Firebase Compatibility**
- [ ] JSON structure is Firebase-friendly
- [ ] Dates stored as Firebase Timestamps (auto-conversion from JS Date)
- [ ] Date conversion utilities handle Timestamp ↔ Date ↔ ISO string
- [ ] Enum values stored as strings

#### ✅ **Validation Integration**
- [ ] Zod schema matches TypeScript interface exactly
- [ ] Flutter validators mapped to equivalent Zod validations
- [ ] Validation error messages match Flutter error semantics
- [ ] Runtime type safety for API boundaries

#### ✅ **Cross-Platform Compatibility**
- [ ] Flutter app can read TypeScript-generated data
- [ ] TypeScript app can read Flutter-generated data
- [ ] No data loss in round-trip conversion
- [ ] Field names match exactly across platforms
- [ ] Date objects preserve exact time values across platforms
- [ ] Flutter DateTime ↔ TypeScript Date ↔ Firebase Timestamp conversion works flawlessly

---

**Apply this process to each model**: `UserProfileModel`, `ReservationItem`, `AttendeeItem`, `ActivityManagerForm`, `ListingManagerForm`, `EventMerchantVendorProfile`, etc.

---

## 3. Core Domain Enums

### 3.1 User & Profile Enums

```typescript
enum ProfileTypeMarker {
  GENERAL_PROFILE = 'generalProfile',
  VENDOR_PROFILE = 'vendorProfile',
  COMMUNITY_PROFILE = 'communityProfile'
}

enum AccountStatus {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  SUSPENDED = 'suspended',
  PENDING_VERIFICATION = 'pendingVerification'
}
```

### 3.2 Activity & Event Enums

```typescript
enum ActivityType {
  CLASSES_LESSONS = 'classesLessons',
  GAME_MATCHES = 'gameMatches',
  EXPERIENCES = 'experiences',
  EVENTS = 'events',
  TO_RENT = 'toRent'
}

enum ActivityStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
  ACTIVE = 'active',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled'
}

enum ReservationType {
  SINGLE_SLOT = 'singleSlot',
  MULTIPLE_SLOTS = 'multipleSlots',
  RECURRING = 'recurring',
  PASS = 'pass'
}

enum ReservationStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  CANCELLED = 'cancelled',
  COMPLETED = 'completed',
  NO_SHOW = 'noShow'
}
```

### 3.3 Attendee & Participation Enums

```typescript
enum AttendeeType {
  FREE = 'free',
  TICKETS = 'tickets',
  PASS = 'pass',
  VENDOR = 'vendor',
  INSTRUCTOR = 'instructor',
  PARTNER = 'partner',
  ORGANIZATION = 'organization',
  INTERESTED = 'interested'
}

enum ContactStatus {
  REQUESTED = 'requested',
  INVITED = 'invited',
  JOINED = 'joined',
  PENDING = 'pending',
  APPROVED = 'approved',
  DECLINED = 'declined',
  CANCELLED = 'cancelled'
}

enum PaymentStatus {
  NO_STATUS = 'noStatus',
  PENDING = 'pending',
  PROCESSING = 'processing',
  COMPLETED = 'completed',
  FAILED = 'failed',
  REFUNDED = 'refunded',
  CANCELLED = 'cancelled'
}
```

### 3.4 Messaging & Communication Enums

```typescript
enum MessageType {
  TEXT = 'text',
  IMAGE = 'image',
  FILE = 'file',
  SYSTEM = 'system',
  POST = 'post'
}

enum RoomType {
  DIRECT = 'direct',
  GROUP = 'group',
  CHANNEL = 'channel',
  ACTIVITY = 'activity'
}
```

### 3.5 Vendor & Merchant Enums

```typescript
enum VendorApplicationStatus {
  DRAFT = 'draft',
  SUBMITTED = 'submitted',
  UNDER_REVIEW = 'underReview',
  APPROVED = 'approved',
  REJECTED = 'rejected'
}

enum ProductCategory {
  FOOD_BEVERAGE = 'foodBeverage',
  CRAFTS_ARTS = 'craftsArts',
  CLOTHING_ACCESSORIES = 'clothingAccessories',
  HEALTH_WELLNESS = 'healthWellness',
  TECHNOLOGY = 'technology',
  SERVICES = 'services',
  OTHER = 'other'
}
```

---

## 4. Value Objects & Complex Types

### 4.1 Location & Address Value Objects
```typescript
interface Address {
  street: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
  coordinates?: Coordinates;
}

interface Coordinates {
  latitude: number;
  longitude: number;
}

interface Location extends Address {
  name?: string;
  description?: string;
  placeId?: string; // Google Places ID
}
```

### 4.2 Time & Scheduling Value Objects
```typescript
interface TimeSlot {
  id: string;
  start: Date;
  end: Date;
  isAvailable: boolean;
  capacity?: number;
  bookedCount: number;
}

interface AvailabilitySettings {
  timeZone: string;
  operatingHours: OperatingHours[];
  blackoutDates: DateRange[];
  minimumBookingNotice: number; // hours
  maximumBookingAdvance: number; // days
}

interface OperatingHours {
  dayOfWeek: number; // 0-6
  isOpen: boolean;
  openTime?: string; // HH:mm format
  closeTime?: string; // HH:mm format
}
```

### 4.3 Pricing & Payment Value Objects
```typescript
interface PricingBreakdown {
  basePrice: number;
  taxes: number;
  fees: number;
  discounts: number;
  total: number;
  currency: string;
}

interface PaymentInformation {
  paymentMethodId?: string;
  paymentIntentId?: string;
  stripeCustomerId?: string;
  lastFourDigits?: string;
  paymentMethod: PaymentMethod;
}

enum PaymentMethod {
  CARD = 'card',
  BANK_TRANSFER = 'bankTransfer',
  DIGITAL_WALLET = 'digitalWallet',
  CASH = 'cash'
}
```

### 4.4 Media & File Value Objects
```typescript
interface MediaFile {
  id: string;
  url: string;
  type: MediaType;
  size: number;
  filename: string;
  alt?: string;
  uploadedAt: Date;
}

enum MediaType {
  IMAGE = 'image',
  VIDEO = 'video',
  DOCUMENT = 'document',
  AUDIO = 'audio'
}
```

---

## 5. Domain Services & Aggregates

### 5.1 Activity Aggregate
```typescript
class ActivityAggregate {
  private constructor(
    public readonly activity: Activity,
    public readonly listing: Listing,
    public readonly attendees: Attendee[],
    public readonly reservations: Reservation[]
  ) {}

  static create(activityData: CreateActivityData): ActivityAggregate {
    // Domain logic for activity creation
  }

  addAttendee(attendee: Attendee): void {
    // Domain logic for adding attendees
  }

  updateAvailability(availability: AvailabilitySettings): void {
    // Domain logic for availability updates
  }
}
```

### 5.2 Reservation Aggregate
```typescript
class ReservationAggregate {
  private constructor(
    public readonly reservation: Reservation,
    public readonly activity: Activity,
    public readonly attendee: Attendee,
    public readonly payments: Payment[]
  ) {}

  static create(reservationData: CreateReservationData): ReservationAggregate {
    // Domain logic for reservation creation
  }

  confirmReservation(): void {
    // Domain logic for confirmation
  }

  cancelReservation(reason: string): void {
    // Domain logic for cancellation
  }
}
```

---

## 9. Priority Implementation Matrix

### High Priority (Phase 1 - Foundation)
1. **Core Entities** - User, Activity, Reservation models
2. **Essential Enums** - Status types, activity types, user types
3. **Value Objects** - Location, pricing, time slots
4. **Validation Schemas** - Zod schemas for API validation
5. **Repository Interfaces** - Data access abstractions

### Medium Priority (Phase 2 - Business Logic)
1. **Domain Aggregates** - Activity, Reservation aggregates
2. **Domain Services** - Complex business logic
3. **Domain Events** - Cross-aggregate communication
4. **Advanced Value Objects** - Complex validation rules
5. **Use Cases** - Application service layer

### Low Priority (Phase 3 - Advanced Features)
1. **Advanced Domain Logic** - Complex business rules
2. **Event Sourcing** - Historical data tracking
3. **Domain Specifications** - Query patterns
4. **Advanced Validation** - Cross-entity validation
5. **Performance Optimizations** - Caching and optimization

---

## 10. Testing Strategy

### 10.1 Domain Model Tests
```typescript
// Unit tests for domain models
describe('ActivityAggregate', () => {
  it('should create activity with valid data', () => {
    const activityData = createValidActivityData();
    const aggregate = ActivityAggregate.create(activityData);
    
    expect(aggregate.activity.id).toBeDefined();
    expect(aggregate.activity.status).toBe(ActivityStatus.DRAFT);
  });

  it('should reject invalid activity data', () => {
    const invalidData = createInvalidActivityData();
    
    expect(() => ActivityAggregate.create(invalidData))
      .toThrow('Invalid activity data');
  });
});
```

### 10.2 Schema Validation Tests
```typescript
// Validation schema tests
describe('ActivitySchema', () => {
  it('should validate correct activity data', () => {
    const validActivity = createValidActivity();
    const result = ActivitySchema.safeParse(validActivity);
    
    expect(result.success).toBe(true);
  });

  it('should reject invalid activity data', () => {
    const invalidActivity = { ...createValidActivity(), title: '' };
    const result = ActivitySchema.safeParse(invalidActivity);
    
    expect(result.success).toBe(false);
    expect(result.error?.issues).toContainEqual(
      expect.objectContaining({
        path: ['title'],
        message: expect.stringContaining('min')
      })
    );
  });
});
```

---

## 11. Performance Considerations

### 11.1 Data Loading Strategies
- **Lazy Loading**: Load related entities on demand
- **Eager Loading**: Pre-load frequently accessed relationships
- **Pagination**: Implement cursor-based pagination for large datasets
- **Caching**: Redis caching for frequently accessed domain objects

### 11.2 Optimization Patterns
```typescript
// Optimized domain queries
interface ActivityQuery {
  location?: Location;
  dateRange?: DateRange;
  type?: ActivityType;
  priceRange?: PriceRange;
  limit?: number;
  cursor?: string;
}

// Result caching
const getCachedActivities = async (query: ActivityQuery): Promise<Activity[]> => {
  const cacheKey = generateCacheKey(query);
  const cached = await redis.get(cacheKey);
  
  if (cached) return JSON.parse(cached);
  
  const activities = await activityRepo.findByQuery(query);
  await redis.setex(cacheKey, 300, JSON.stringify(activities)); // 5min cache
  
  return activities;
};
```

---

## Conclusion

The `check_in_domain` package represents a sophisticated domain model that captures the complexity of a dual-sided marketplace platform. The migration to TypeScript/Next.js requires careful consideration of:

1. **Type Safety**: Leveraging TypeScript's type system for compile-time validation
2. **Validation**: Using Zod for runtime validation and API safety
3. **Domain Logic**: Preserving business rules through aggregates and domain services
4. **Performance**: Implementing efficient data access and caching strategies
5. **Maintainability**: Clear separation of concerns and testable code structure

The recommended approach maintains the domain-driven design principles while adapting to TypeScript/JavaScript ecosystem patterns. This foundation will support the complex business logic requirements while providing excellent developer experience and type safety.

**Next Steps**: Begin with Phase 1 implementation focusing on core entities and validation schemas, then progressively build the domain logic and advanced features in subsequent phases.