# Check-In Domain: Simplified TypeScript Models
## Exact Field Mapping with TypeScript Simplicity

### Executive Summary
Following the `cico-dashboard-web` approach with `reservation.ts` and `ReservationSlotItem`, we'll create simplified TypeScript models that maintain **exact field compatibility** with Flutter domain models while leveraging TypeScript's simplicity and Firebase's string-based storage.

---

## 1. Simplified TypeScript Domain Structure

```typescript
src/domain/
├── entities/
│   ├── user.entity.ts              # UserProfileModel
│   ├── vendor.entity.ts            # EventMerchantVendorProfile  
│   ├── attendee.entity.ts          # AttendeeItem
│   ├── listing.entity.ts           # ListingManagerForm
│   ├── reservation.entity.ts       # ReservationItem + sub-models
│   └── activity.entity.ts          # ActivityManagerForm + sub-models
├── enums/
│   ├── attendee.enums.ts           # AttendeeType, ContactStatus, etc.
│   ├── activity.enums.ts           # ActivityType, ReservationType, etc.
│   └── payment.enums.ts            # PaymentStatus, PaymentMethod, etc.
├── types/
│   ├── common.types.ts             # Shared interfaces
│   └── api.types.ts                # API request/response types
└── schemas/
    ├── user.schema.ts              # Zod validation schemas
    ├── reservation.schema.ts
    └── activity.schema.ts
```

---

## 2. Core Models - Simplified Approach

### 2.1 UserProfileModel (Exact Fields)
```typescript
// src/domain/entities/user.entity.ts
export interface UserProfileModel {
  // CRITICAL: All fields from Flutter exactly as they exist
  userId: string;                     // .userId.getOrCrash() → simple string
  legalName: string;                  // .legalName.getOrCrash() → simple string
  legalSurname?: string;              // .legalSurname.value.fold() → optional string
  emailAddress: string;               // .emailAddress.getOrCrash() → simple string
  phoneNumber?: string;               // .phoneNumber?.value → optional string
  profileImageUrl?: string;           // Profile image URL
  dateOfBirth?: string;               // ISO date string (Firebase compatible)
  
  // Nested models as simple objects
  address?: Address;
  socialMediaProfiles: SocialMediaProfile[];
  accountSettings: AccountSettings;
  privacySettings: PrivacySettings;
  
  // Metadata
  createdAt: string;                  // ISO date string
  updatedAt: string;                  // ISO date string
}

// Sub-models (simplified)
export interface Address {
  street: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
  coordinates?: {
    latitude: number;
    longitude: number;
  };
}

export interface SocialMediaProfile {
  platform: string;                  // 'instagram', 'facebook', etc.
  username: string;
  url?: string;
}

export interface AccountSettings {
  notifications: boolean;
  privacy: 'public' | 'private' | 'friends';
  language: string;
  timezone: string;
}

export interface PrivacySettings {
  showEmail: boolean;
  showPhone: boolean;
  showAddress: boolean;
}
```

### 2.2 EventMerchantVendorProfile (Exact Fields)
```typescript
// src/domain/entities/vendor.entity.ts
export interface EventMerchantVendorProfile {
  profileId: string;                  // .profileId.getOrCrash()
  brandName: string;                  // .brandName.getOrCrash()
  businessName?: string;              // Business legal name
  businessDescription?: string;       // .businessDescription
  
  // Business details
  categories: ProductCategory[];      // Array of enum values
  businessType?: BusinessType;        // Enum value
  
  // Contact and verification
  contactInformation: ContactInformation;
  businessAddress?: Address;
  isVerified: boolean;
  verificationDocuments?: string[];   // Array of file URLs
  
  // Financial
  paymentInformation?: PaymentInformation;
  taxInformation?: TaxInformation;
  
  // Performance metrics (simplified)
  rating: number;                     // 0-5 rating
  reviewCount: number;
  totalSales: number;                 // Simple number in cents
  
  // Metadata
  createdAt: string;
  updatedAt: string;
}

export interface ContactInformation {
  email: string;
  phone?: string;
  website?: string;
  address?: Address;
}

export interface PaymentInformation {
  stripeAccountId?: string;
  paymentMethods: PaymentMethod[];
  defaultCurrency: string;            // 'USD', 'EUR', etc.
}

export interface TaxInformation {
  businessLicense?: string;
  taxId?: string;
  vatNumber?: string;
}
```

### 2.3 AttendeeItem (Exact Fields)
```typescript
// src/domain/entities/attendee.entity.ts
export interface AttendeeItem {
  attendeeId: string;                 // .attendeeId.getOrCrash()
  attendeeOwnerId: string;            // .attendeeOwnerId.getOrCrash()
  reservationId: string;              // Link to reservation
  
  // Type and status (enums as strings)
  attendeeType: AttendeeType;         // 'free' | 'tickets' | 'vendor' | etc.
  contactStatus: ContactStatus;       // 'joined' | 'pending' | etc.
  paymentStatus: PaymentStatus;       // 'completed' | 'pending' | etc.
  
  // Payment details (simplified)
  cost: string;                       // String representation (as in Flutter)
  paymentIntentId?: string;
  
  // Related entities (optional references)
  eventMerchantVendorProfile?: EventMerchantVendorProfile;
  vendorForm?: VendorMerchantForm;
  ticketItems?: TicketItem[];
  
  // Metadata
  dateCreated: string;                // ISO date string
  applicationDate?: string;
  approvalDate?: string;
}

export interface TicketItem {
  ticketId: string;
  ticketType: string;
  quantity: number;
  pricePerTicket: number;             // In cents
  totalPrice: number;                 // In cents
  selectedTicketFee: number;          // In cents
  currency: string;
}

export interface VendorMerchantForm {
  formId: string;
  boothRequirements?: string;
  specialRequests?: string;
  equipmentNeeded?: string[];
  customOptions?: Record<string, any>; // Flexible key-value pairs
}
```

### 2.4 ReservationItem + Sub-models (Like cico-dashboard-web)
```typescript
// src/domain/entities/reservation.entity.ts
export interface ReservationItem {
  reservationId: string;              // .reservationId.getOrCrash()
  instanceId: string;                 // .instanceId
  reservationOwnerId: string;         // .reservationOwnerId.getOrCrash()
  
  // Type and status
  reservationType: ReservationType;   // 'singleSlot' | 'multipleSlots' | etc.
  reservationStatus: ReservationStatus; // 'confirmed' | 'pending' | etc.
  
  // Time slots (like ReservationSlotItem in cico-dashboard-web)
  selectedSlots: ReservationSlotItem[];
  
  // Pricing (simplified)
  pricing: PricingBreakdown;
  
  // Payment
  paymentInfo?: PaymentInformation;
  
  // Metadata
  createdAt: string;
  updatedAt: string;
}

// Sub-model: ReservationSlotItem (following cico-dashboard-web pattern)
export interface ReservationSlotItem {
  slotId: string;
  startTime: string;                  // ISO date string
  endTime: string;                    // ISO date string
  capacity: number;
  bookedCount: number;
  isAvailable: boolean;
  slotType?: string;                  // 'regular' | 'premium' | etc.
}

// Sub-model: PricingBreakdown (simplified)
export interface PricingBreakdown {
  basePrice: number;                  // In cents
  taxes: number;                      // In cents
  fees: number;                       // In cents
  discounts: number;                  // In cents
  total: number;                      // In cents
  currency: string;                   // 'USD' | 'EUR' | etc.
}
```

### 2.5 ListingManagerForm (Exact Fields)
```typescript
// src/domain/entities/listing.entity.ts
export interface ListingManagerForm {
  listingServiceId: string;           // .listingServiceId.getOrCrash()
  facilityName: string;               // Facility name
  facilityDescription?: string;       // Description
  
  // Spaces and amenities
  spaces: SpaceOption[];
  amenities: Amenity[];
  
  // Contact and location
  contactInfo: ContactInformation;
  location: Address;
  
  // Pricing and availability
  pricingModel: PricingModel;
  availabilitySettings: AvailabilitySettings;
  
  // Rules and policies
  rules: Rule[];
  
  // Media
  images: string[];                   // Array of image URLs
  videos?: string[];                  // Array of video URLs
  
  // Owner and status
  ownerId: string;
  listingStatus: ListingStatus;       // 'active' | 'inactive' | 'pending'
  
  // Metadata
  createdAt: string;
  updatedAt: string;
}

export interface SpaceOption {
  spaceId: string;
  spaceName: string;
  spaceType: string;                  // 'indoor' | 'outdoor' | 'mixed'
  capacity: number;
  squareFootage?: number;
  amenities: string[];                // Array of amenity IDs
  basePrice: number;                  // In cents per hour/day
}

export interface Amenity {
  amenityId: string;
  name: string;
  category: string;                   // 'technology' | 'furniture' | etc.
  isIncluded: boolean;                // Included in base price
  additionalCost?: number;            // In cents if not included
}

export interface PricingModel {
  baseRate: number;                   // In cents
  rateType: 'hourly' | 'daily' | 'weekly' | 'monthly';
  minimumBooking: number;             // Minimum hours/days
  maximumBooking?: number;            // Maximum hours/days
  seasonalRates?: SeasonalRate[];
}

export interface SeasonalRate {
  startDate: string;                  // ISO date
  endDate: string;                    // ISO date
  multiplier: number;                 // 1.5 = 150% of base rate
  description?: string;
}

export interface AvailabilitySettings {
  timeZone: string;
  operatingHours: OperatingHours[];
  blackoutDates: string[];            // Array of ISO dates
  minimumNotice: number;              // Hours before booking
  maximumAdvance: number;             // Days in advance
}

export interface OperatingHours {
  dayOfWeek: number;                  // 0-6 (Sunday-Saturday)
  isOpen: boolean;
  openTime?: string;                  // 'HH:mm' format
  closeTime?: string;                 // 'HH:mm' format
}

export interface Rule {
  ruleId: string;
  title: string;
  description: string;
  category: 'safety' | 'conduct' | 'equipment' | 'general';
  isRequired: boolean;
}
```

### 2.6 ActivityManagerForm (Exact Fields + Sub-models)
```typescript
// src/domain/entities/activity.entity.ts
export interface ActivityManagerForm {
  activityFormId: string;             // .activityFormId.getOrCrash()
  
  // Major sub-models (simplified as nested objects)
  activityBackground: ActivityBackground;
  activityAvailability: ActivityAvailability;
  activityAttendance: ActivityAttendance;
  rulesService: RulesService;
  profileService: ProfileService;
  
  // Direct properties
  activityType: ActivityType;         // Enum as string
  reservationItem?: ReservationItem;  // Optional linked reservation
  
  // Metadata
  createdAt: string;
  updatedAt: string;
}

// Sub-model: ActivityBackground
export interface ActivityBackground {
  activityTitle: string;              // .activityTitle.value.fold() → simple string
  activityDescription?: string;
  activityProfileImages?: ActivityImage[];
  classActivityBackground?: ClassActivityBackground;
}

export interface ActivityImage {
  imageId: string;
  imageUrl: string;                   // Direct URL (not Uint8List)
  altText?: string;
  isDefault: boolean;
}

export interface ClassActivityBackground {
  experience?: Experience[];
  certificates?: Certificate[];
  numberOfYearsInExperience?: number;
}

export interface Experience {
  experienceId: string;
  experienceName: string;
  experiencePeriod: {
    start: string;                    // ISO date
    end: string;                      // ISO date
  };
  description?: string;
}

export interface Certificate {
  certificateId: string;
  certificateType: string;
  certificateName: string;
  issuedDate?: string;                // ISO date
  expiryDate?: string;                // ISO date
}

// Sub-model: ActivityAttendance
export interface ActivityAttendance {
  isTicketBased: boolean;             // .activityAttendance.isTicketBased
  isPassBased: boolean;               // .activityAttendance.isPassBased
  isTicketFixed: boolean;             // .activityAttendance.isTicketFixed
  isTicketPerSlotBased: boolean;      // .activityAttendance.isTicketPerSlotBased
  
  // Ticket options
  defaultActivityTickets?: ActivityTicketOption;
  activityTickets?: ActivityTicketOption[];
}

export interface ActivityTicketOption {
  ticketId: string;
  ticketName: string;
  ticketDescription?: string;
  ticketQuantity: number;
  ticketPrice: number;                // In cents
  currency: string;
  isUnlimited: boolean;
}

// Sub-model: RulesService (MASSIVE but simplified)
export interface RulesService {
  currency: string;                   // .rulesService.currency
  accessVisibilitySetting: AccessVisibilitySetting;
  cancellationSettings: CancellationSettings;
  checkInSetting: CheckInSetting[];
  customFieldRuleSetting: CustomFieldRule[];
  vendorMerchantForms?: VendorMerchantForm[];
}

export interface AccessVisibilitySetting {
  isPrivateOnly?: boolean;            // .accessVisibilitySetting.isPrivateOnly
  isPublic?: boolean;
  isInviteOnly?: boolean;
  isReviewRequired?: boolean;
  allowedUserIds?: string[];
  blockedUserIds?: string[];
}

export interface CancellationSettings {
  isNotAllowedCancellation?: boolean; // .isNotAllowedCancellation
  isAllowedFeeBasedChanges?: boolean; // .isAllowedFeeBasedChanges
  isAllowedTimeBasedChanges?: boolean; // .isAllowedTimeBasedChanges
  feeBasedCancellationOptions?: FeeCancellationOption[];
  timeBasedCancellationOptions?: TimeCancellationOption[];
}

export interface FeeCancellationOption {
  optionId: string;
  feePercentage: number;              // 0-100
  description: string;
  isActive: boolean;
}

export interface TimeCancellationOption {
  optionId: string;
  hoursBeforeEvent: number;
  feePercentage: number;              // 0-100
  description: string;
  isActive: boolean;
}

export interface CheckInSetting {
  settingId: string;
  settingName: string;
  settingValue: string;
  isRequired: boolean;
}

export interface CustomFieldRule {
  ruleId: string;
  fieldName: string;
  fieldType: 'text' | 'number' | 'boolean' | 'select' | 'multiselect';
  isRequired: boolean;
  options?: string[];                 // For select/multiselect
  validation?: string;                // Regex or validation rule
}

// Sub-model: ProfileService
export interface ProfileService {
  activityBackground: ActivityBackground;     // Reference to above
  activityRequirements: ActivityRequirements;
}

export interface ActivityRequirements {
  // Age restrictions
  isSeventeenAndUnder: boolean;       // .isSeventeenAndUnder
  minimumAgeRequirement: number;      // .minimumAgeRequirement
  
  // Gender restrictions
  isMensOnly?: boolean;               // .isMensOnly
  isWomenOnly?: boolean;              // .isWomenOnly
  isCoEdOnly?: boolean;               // .isCoEdOnly
  
  // Skill and equipment
  skillLevelExpectation?: SkillLevel[];
  isGearProvided?: boolean;           // .isGearProvided
  isEquipmentProvided?: boolean;      // .isEquipmentProvided
  isAnalyticsProvided?: boolean;      // .isAnalyticsProvided
  isOfficiatorProvided?: boolean;     // .isOfficiatorProvided
  
  // Event-specific (nested structure simplified)
  eventActivityRulesRequirement?: EventActivityRulesRequirement;
}

export interface EventActivityRulesRequirement {
  isAlcoholForSale?: boolean;         // .isAlcoholForSale
  isFoodForSale?: boolean;            // .isFoodForSale
  isMerchantInviteOnly?: boolean;     // .isMerchantInviteOnly
  merchantLimit?: number;             // .merchantLimit
  merchantFee?: number;               // .merchantFee (in cents)
  
  // Services provided
  isAlcoholProvided?: boolean;        // .isAlcoholProvided
  isFoodProvided?: boolean;           // .isFoodProvided
  isSecurityProvided?: boolean;       // .isSecurityProvided
}
```

---

## 3. Enums (String Literals - Firebase Compatible)

```typescript
// src/domain/enums/attendee.enums.ts
export type AttendeeType = 
  | 'free' 
  | 'tickets' 
  | 'pass' 
  | 'vendor' 
  | 'instructor' 
  | 'partner' 
  | 'organization' 
  | 'interested';

export type ContactStatus = 
  | 'requested' 
  | 'invited' 
  | 'joined' 
  | 'pending' 
  | 'approved' 
  | 'declined' 
  | 'cancelled';

export type PaymentStatus = 
  | 'noStatus' 
  | 'pending' 
  | 'processing' 
  | 'completed' 
  | 'failed' 
  | 'refunded' 
  | 'cancelled';

// src/domain/enums/activity.enums.ts
export type ActivityType = 
  | 'classesLessons' 
  | 'gameMatches' 
  | 'experiences' 
  | 'events' 
  | 'toRent';

export type ReservationType = 
  | 'singleSlot' 
  | 'multipleSlots' 
  | 'recurring' 
  | 'pass';

export type ReservationStatus = 
  | 'pending' 
  | 'confirmed' 
  | 'cancelled' 
  | 'completed' 
  | 'noShow';

export type ListingStatus = 
  | 'active' 
  | 'inactive' 
  | 'pending' 
  | 'suspended';

// src/domain/enums/payment.enums.ts
export type PaymentMethod = 
  | 'card' 
  | 'bankTransfer' 
  | 'digitalWallet' 
  | 'cash';

export type ProductCategory = 
  | 'foodBeverage' 
  | 'craftsArts' 
  | 'clothingAccessories' 
  | 'healthWellness' 
  | 'technology' 
  | 'services' 
  | 'other';

export type BusinessType = 
  | 'sole_proprietorship' 
  | 'partnership' 
  | 'corporation' 
  | 'llc' 
  | 'nonprofit';

export type SkillLevel = 
  | 'beginner' 
  | 'intermediate' 
  | 'advanced' 
  | 'expert';
```

---

## 4. Validation Schemas (Zod)

```typescript
// src/domain/schemas/user.schema.ts
import { z } from 'zod';

export const UserProfileSchema = z.object({
  userId: z.string().uuid(),
  legalName: z.string().min(1).max(100),
  legalSurname: z.string().max(100).optional(),
  emailAddress: z.string().email(),
  phoneNumber: z.string().optional(),
  profileImageUrl: z.string().url().optional(),
  dateOfBirth: z.string().datetime().optional(),
  address: z.object({
    street: z.string(),
    city: z.string(),
    state: z.string(),
    zipCode: z.string(),
    country: z.string(),
    coordinates: z.object({
      latitude: z.number().min(-90).max(90),
      longitude: z.number().min(-180).max(180),
    }).optional(),
  }).optional(),
  socialMediaProfiles: z.array(z.object({
    platform: z.string(),
    username: z.string(),
    url: z.string().url().optional(),
  })),
  accountSettings: z.object({
    notifications: z.boolean(),
    privacy: z.enum(['public', 'private', 'friends']),
    language: z.string(),
    timezone: z.string(),
  }),
  privacySettings: z.object({
    showEmail: z.boolean(),
    showPhone: z.boolean(),
    showAddress: z.boolean(),
  }),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

export type UserProfile = z.infer<typeof UserProfileSchema>;
```

---

## 5. API Compatibility Layer

```typescript
// src/domain/types/api.types.ts
export interface ApiResponse<T> {
  data: T;
  success: boolean;
  message?: string;
  errors?: string[];
  meta?: {
    total?: number;
    page?: number;
    limit?: number;
    platform: 'flutter' | 'nextjs';
  };
}

// Transformation utilities
export class ModelTransformer {
  // Convert Flutter's complex patterns to simple TypeScript
  static fromFlutter<T>(flutterData: any): T {
    // Handle value.fold patterns
    if (flutterData?.value?.fold) {
      return flutterData.value.fold(
        (error: any) => { throw new Error(error.toString()); },
        (value: T) => value
      );
    }
    
    // Handle getOrCrash patterns
    if (flutterData?.getOrCrash) {
      return flutterData.getOrCrash();
    }
    
    return flutterData;
  }
  
  // Simple object mapping for nested structures
  static mapObject<T>(obj: any, mapper: (key: string, value: any) => any): T {
    const result: any = {};
    for (const [key, value] of Object.entries(obj)) {
      result[key] = mapper(key, value);
    }
    return result as T;
  }
}
```

---

## 6. Next.js API Integration

```typescript
// pages/api/users/[id].ts
import { NextApiRequest, NextApiResponse } from 'next';
import { UserProfileSchema } from '@/domain/schemas/user.schema';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === 'GET') {
    try {
      const { id } = req.query;
      const platform = req.headers['x-platform'] || 'nextjs';
      
      // Fetch from Firebase (already string-based)
      const userData = await fetchUserFromFirebase(id as string);
      
      // Validate with Zod
      const validatedUser = UserProfileSchema.parse(userData);
      
      // Return platform-appropriate format
      const response = {
        data: validatedUser,
        success: true,
        meta: { platform }
      };
      
      res.status(200).json(response);
    } catch (error) {
      res.status(400).json({
        success: false,
        message: 'Invalid user data',
        errors: error instanceof Error ? [error.message] : ['Unknown error']
      });
    }
  }
}
```

---

## 7. Benefits of This Approach

### ✅ **Simplified Complexity**
- No Flutter value object patterns (`.value.fold()`, `.getOrCrash()`)
- Direct string/number types that work with Firebase
- Clean, readable TypeScript interfaces

### ✅ **Exact Field Compatibility**  
- Every field from Flutter models mapped exactly
- Same field names and structure
- Compatible with existing Firebase data

### ✅ **Developer Experience**
- Easy to read and maintain
- IDE autocomplete and type checking
- Simple validation with Zod

### ✅ **Firebase Integration**
- String-based data types work perfectly with Firestore
- No complex serialization/deserialization
- Direct JSON compatibility

### ✅ **API Compatibility**
- Same data flowing to Flutter and Next.js
- Platform detection for format adjustments
- Validation ensures data integrity

---

## Next Steps

1. **Start with Core Models**: Implement `UserProfileModel`, `ReservationItem`, `AttendeeItem`
2. **Add Validation**: Create Zod schemas for runtime validation
3. **Test Compatibility**: Ensure Flutter app can read/write the same data
4. **Iterate on Sub-models**: Add complexity gradually as needed
5. **API Integration**: Build Next.js API routes with validation

This approach gives you the **simplicity of TypeScript** while maintaining **perfect compatibility** with your existing Flutter domain models. The Firebase string-based storage works seamlessly, and you avoid the complexity of Flutter's value object patterns while keeping all the business logic intact.

Ready to move forward with this simplified approach?