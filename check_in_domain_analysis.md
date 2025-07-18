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

## 2. Core Domain Models Analysis

### 2.1 User & Profile Domain

#### **UserProfileModel**
**Current Implementation**: Core user entity with comprehensive profile data
```dart
class UserProfileModel {
  final UniqueId userId;
  final LegalName legalName;
  final EmailAddress emailAddress;
  final PhoneNumber phoneNumber;
  final ProfileImageUrl profileImageUrl;
  final DateOfBirth dateOfBirth;
  final Address address;
  final List<SocialMediaProfile> socialMediaProfiles;
  final AccountSettings accountSettings;
  final PrivacySettings privacySettings;
}
```

**Features Identified**:
- ✅ Unique identifier management
- ✅ Legal name and contact information
- ✅ Profile image and media handling
- ✅ Address and location data
- ✅ Social media integration
- ✅ Account and privacy settings
- ✅ Multi-profile support (general, vendor, merchant)

**TypeScript Implementation**:
```typescript
interface UserProfile {
  id: string;
  legalName: string;
  email: string;
  phone?: string;
  profileImageUrl?: string;
  dateOfBirth?: Date;
  address?: Address;
  socialMediaProfiles: SocialMediaProfile[];
  accountSettings: AccountSettings;
  privacySettings: PrivacySettings;
  createdAt: Date;
  updatedAt: Date;
}
```

#### **EventMerchantVendorProfile** 
**Current Implementation**: Vendor-specific profile for marketplace participants
```dart
class EventMerchantVendorProfile {
  final UniqueId profileId;
  final BusinessName businessName;
  final BusinessDescription description;
  final List<ProductCategory> categories;
  final BusinessLicense license;
  final ContactInformation contactInfo;
  final PaymentInformation paymentInfo;
}
```

**TypeScript Implementation**:
```typescript
interface VendorProfile {
  id: string;
  businessName: string;
  description: string;
  categories: ProductCategory[];
  license?: BusinessLicense;
  contactInfo: ContactInformation;
  paymentInfo: PaymentInformation;
  isVerified: boolean;
  rating: number;
  reviewCount: number;
}
```

### 2.2 Activity & Event Management Domain

#### **ActivityManagerForm**
**Current Implementation**: Comprehensive activity creation and management
```dart
class ActivityManagerForm {
  final UniqueId activityFormId;
  final ActivityType activityType;
  final ActivityBackground activityBackground;
  final ActivityAvailability activityAvailability;
  final ActivityAttendance activityAttendance;
  final RulesService rulesService;
  final ProfileService profileService;
  final SettingsService settingsService;
}
```

**Features Identified**:
- ✅ Multi-type activity support (classes, games, experiences, events)
- ✅ Background information and media
- ✅ Availability and scheduling
- ✅ Attendee management
- ✅ Rules and requirements
- ✅ Pricing and payment settings

**TypeScript Implementation**:
```typescript
interface Activity {
  id: string;
  type: ActivityType;
  title: string;
  description: string;
  background: ActivityBackground;
  availability: ActivityAvailability;
  attendance: ActivityAttendance;
  rules: ActivityRules;
  pricing: ActivityPricing;
  location: Location;
  organizer: UserProfile;
  status: ActivityStatus;
  createdAt: Date;
  updatedAt: Date;
}
```

#### **ReservationItem**
**Current Implementation**: Booking and reservation management
```dart
class ReservationItem {
  final UniqueId reservationId;
  final UniqueId instanceId;
  final UniqueId reservationOwnerId;
  final ReservationType reservationType;
  final List<TimeSlot> selectedSlots;
  final PricingBreakdown pricing;
  final ReservationStatus status;
  final PaymentInformation paymentInfo;
}
```

**TypeScript Implementation**:
```typescript
interface Reservation {
  id: string;
  activityId: string;
  userId: string;
  type: ReservationType;
  timeSlots: TimeSlot[];
  pricing: PricingBreakdown;
  status: ReservationStatus;
  paymentInfo: PaymentInformation;
  createdAt: Date;
  updatedAt: Date;
}
```

### 2.3 Facility & Listing Management Domain

#### **ListingManagerForm**
**Current Implementation**: Facility and venue management
```dart
class ListingManagerForm {
  final UniqueId listingServiceId;
  final FacilityName facilityName;
  final FacilityDescription description;
  final List<SpaceOption> spaces;
  final List<Amenity> amenities;
  final ContactInformation contactInfo;
  final PricingModel pricing;
  final AvailabilitySettings availability;
  final List<Rule> rules;
}
```

**TypeScript Implementation**:
```typescript
interface Listing {
  id: string;
  name: string;
  description: string;
  spaces: Space[];
  amenities: Amenity[];
  contactInfo: ContactInformation;
  pricing: PricingModel;
  availability: AvailabilitySettings;
  rules: Rule[];
  location: Location;
  owner: UserProfile;
  images: string[];
  status: ListingStatus;
}
```

### 2.4 Attendee & Participation Domain

#### **AttendeeItem**
**Current Implementation**: Participant management for activities
```dart
class AttendeeItem {
  final UniqueId attendeeId;
  final UniqueId attendeeOwnerId;
  final UniqueId reservationId;
  final AttendeeType attendeeType;
  final ContactStatus contactStatus;
  final PaymentStatusType paymentStatus;
  final String cost;
  final String paymentIntentId;
  final EventMerchantVendorProfile? eventMerchantVendorProfile;
  final List<TicketItem>? ticketItems;
  final VendorMerchantForm? vendorForm;
}
```

**TypeScript Implementation**:
```typescript
interface Attendee {
  id: string;
  userId: string;
  activityId: string;
  type: AttendeeType;
  contactStatus: ContactStatus;
  paymentStatus: PaymentStatus;
  cost: number;
  paymentIntentId?: string;
  vendorProfile?: VendorProfile;
  tickets?: Ticket[];
  vendorForm?: VendorForm;
  applicationDate: Date;
  approvalDate?: Date;
}
```

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

## 6. Validation Schemas (Zod)

### 6.1 User Profile Schema
```typescript
import { z } from 'zod';

export const UserProfileSchema = z.object({
  id: z.string().uuid(),
  legalName: z.string().min(2).max(100),
  email: z.string().email(),
  phone: z.string().optional(),
  profileImageUrl: z.string().url().optional(),
  dateOfBirth: z.date().optional(),
  address: AddressSchema.optional(),
  socialMediaProfiles: z.array(SocialMediaProfileSchema),
  accountSettings: AccountSettingsSchema,
  privacySettings: PrivacySettingsSchema,
  createdAt: z.date(),
  updatedAt: z.date()
});

export type UserProfile = z.infer<typeof UserProfileSchema>;
```

### 6.2 Activity Schema
```typescript
export const ActivitySchema = z.object({
  id: z.string().uuid(),
  type: z.nativeEnum(ActivityType),
  title: z.string().min(3).max(200),
  description: z.string().min(10).max(2000),
  background: ActivityBackgroundSchema,
  availability: AvailabilitySettingsSchema,
  attendance: ActivityAttendanceSchema,
  rules: ActivityRulesSchema,
  pricing: PricingModelSchema,
  location: LocationSchema,
  organizer: UserProfileSchema,
  status: z.nativeEnum(ActivityStatus),
  createdAt: z.date(),
  updatedAt: z.date()
});

export type Activity = z.infer<typeof ActivitySchema>;
```

---

## 7. Migration Strategy from Flutter Domain Models

### 7.1 Data Type Conversions
```typescript
// Flutter Dart → TypeScript conversions
const typeMapping = {
  'UniqueId': 'string',           // UUID strings
  'dart.Either': 'Result<T, E>',  // Result type pattern
  'dart.Option': 'T | null',      // Optional values
  'DateTime': 'Date',             // JavaScript Date
  'List<T>': 'T[]',              // Arrays
  'Map<K,V>': 'Record<K, V>',    // Objects/Maps
};
```

### 7.2 Value Object Pattern
```typescript
// Instead of Dart value objects, use branded types
type UserId = string & { readonly brand: unique symbol };
type Email = string & { readonly brand: unique symbol };

// Factory functions for validation
export const createUserId = (id: string): UserId => {
  if (!isValidUUID(id)) throw new Error('Invalid user ID');
  return id as UserId;
};

export const createEmail = (email: string): Email => {
  if (!isValidEmail(email)) throw new Error('Invalid email');
  return email as Email;
};
```

### 7.3 Domain Event System
```typescript
// Domain events for cross-aggregate communication
export abstract class DomainEvent {
  public readonly occurredOn: Date = new Date();
  public readonly aggregateId: string;
  
  constructor(aggregateId: string) {
    this.aggregateId = aggregateId;
  }
}

export class ActivityCreatedEvent extends DomainEvent {
  constructor(
    aggregateId: string,
    public readonly activity: Activity
  ) {
    super(aggregateId);
  }
}
```

---

## 8. Next.js Implementation Recommendations

### 8.1 Repository Pattern
```typescript
// Domain repository interfaces
export interface UserRepository {
  findById(id: UserId): Promise<UserProfile | null>;
  save(user: UserProfile): Promise<void>;
  findByEmail(email: Email): Promise<UserProfile | null>;
}

export interface ActivityRepository {
  findById(id: string): Promise<Activity | null>;
  save(activity: Activity): Promise<void>;
  findByLocation(location: Location): Promise<Activity[]>;
  findByDateRange(start: Date, end: Date): Promise<Activity[]>;
}
```

### 8.2 Use Case Layer
```typescript
// Application use cases
export class CreateActivityUseCase {
  constructor(
    private activityRepo: ActivityRepository,
    private userRepo: UserRepository,
    private eventBus: EventBus
  ) {}

  async execute(command: CreateActivityCommand): Promise<Activity> {
    // Validate permissions
    const organizer = await this.userRepo.findById(command.organizerId);
    if (!organizer) throw new Error('Organizer not found');

    // Create activity aggregate
    const activity = ActivityAggregate.create(command.activityData);
    
    // Save and publish events
    await this.activityRepo.save(activity.activity);
    await this.eventBus.publish(new ActivityCreatedEvent(activity.activity.id, activity.activity));
    
    return activity.activity;
  }
}
```

### 8.3 API Layer Integration
```typescript
// Next.js API route with domain validation
import { NextRequest, NextResponse } from 'next/server';
import { ActivitySchema } from '@/domain/schemas';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const activityData = ActivitySchema.parse(body);
    
    const useCase = container.get<CreateActivityUseCase>('CreateActivityUseCase');
    const activity = await useCase.execute({ activityData });
    
    return NextResponse.json(activity, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({ errors: error.errors }, { status: 400 });
    }
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
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