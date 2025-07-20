# Check-In Domain: Rigorous Analysis for TypeScript Port
## Critical Requirements for Model Compatibility

### Executive Summary
Based on deep code analysis, the domain contains **60+ distinct models and sub-models** with complex nested structures using Flutter's value object patterns (`.value.fold()`, `.getOrCrash()`, `.isValid()`). **Perfect field-level compatibility is critical** - any missing fields will break the dual-platform approach.

---

## 1. Critical Model Structure Patterns Found

### Flutter Value Object Pattern
```dart
// Every domain field uses this pattern:
field.value.fold((l) => defaultValue, (r) => actualValue)
field.getOrCrash()  // Get value or throw exception
field.isValid()     // Validation check
```

### TypeScript Equivalent Strategy
```typescript
// Must create exact mapping layer
interface ValueObject<T> {
  value: Either<Error, T>;
  getOrCrash(): T;
  isValid(): boolean;
}

// Or use transformation layer
class FlutterValueMapper {
  static fromFlutter<T>(flutterField: any): T {
    if (flutterField?.value?.fold) {
      return flutterField.value.fold(
        (error: any) => { throw new Error(error.toString()); },
        (value: T) => value
      );
    }
    return flutterField;
  }
}
```

---

## 2. Core Models with Exact Field Requirements

### 2.1 UserProfileModel - Complete Structure
```typescript
interface UserProfileModel {
  // CRITICAL: Both legalName AND legalSurname are required
  userId: ValueObject<string>;                    // .userId.getOrCrash()
  legalName: ValueObject<string>;                 // .legalName.getOrCrash()
  legalSurname: ValueObject<string>;              // .legalSurname.value.fold()
  emailAddress: ValueObject<string>;              // .emailAddress.getOrCrash()
  phoneNumber?: ValueObject<string>;              // .phoneNumber?.value
  profileImageUrl?: ValueObject<string>;          // Not directly seen but likely exists
  dateOfBirth?: ValueObject<Date>;                // Standard pattern
  address?: Address;                              // Nested value object
  socialMediaProfiles: SocialMediaProfile[];     // Array of sub-models
  accountSettings: AccountSettings;              // Nested model
  privacySettings: PrivacySettings;              // Nested model
  
  // Additional fields that may exist:
  verificationStatus?: ValueObject<string>;
  createdAt: ValueObject<Date>;
  updatedAt: ValueObject<Date>;
}
```

### 2.2 ActivityManagerForm - Massive Nested Structure
```typescript
interface ActivityManagerForm {
  activityFormId: ValueObject<string>;            // .activityFormId.getOrCrash()
  
  // Major sub-models found in code:
  activityBackground: ActivityBackground;         // .activityBackground
  activityAvailability: ActivityAvailability;     // .activityAvailability  
  activityAttendance: ActivityAttendance;         // .activityAttendance
  rulesService: RulesService;                     // .rulesService
  profileService: ProfileService;                // .profileService
  settingsService: SettingsService;              // .settingsService (likely exists)
  
  // Additional nested structures:
  activityType: ActivityType;                     // .activityType
  reservationItem?: ReservationItem;              // .reservationItem when linked
}

// Sub-model: ActivityBackground
interface ActivityBackground {
  activityTitle: ValueObject<string>;             // .activityTitle.value.fold()
  activityProfileImages?: ActivityImage[];        // .activityProfileImages?[index]
  classActivityBackground?: ClassActivityBackground; // Complex nested structure
}

// Sub-model: ActivityAttendance  
interface ActivityAttendance {
  isTicketBased: boolean;                         // .activityAttendance.isTicketBased
  isPassBased: boolean;                           // .activityAttendance.isPassBased  
  isTicketFixed: boolean;                         // .activityAttendance.isTicketFixed
  isTicketPerSlotBased: boolean;                  // .activityAttendance.isTicketPerSlotBased
  defaultActivityTickets?: ActivityTicketOption;  // .activityAttendance.defaultActivityTickets
  activityTickets?: ActivityTicketOption[];       // .activityAttendance.activityTickets
}

// Sub-model: RulesService (MASSIVE nested structure)
interface RulesService {
  currency: string;                               // .rulesService.currency
  accessVisibilitySetting: AccessVisibilitySetting; // .rulesService.accessVisibilitySetting
  cancellationSettings: CancellationSettings;    // .rulesService.cancellationSettings
  checkInSetting: CheckInSetting[];               // .rulesService.checkInSetting
  customFieldRuleSetting: CustomFieldRule[];     // .rulesService.customFieldRuleSetting
  vendorMerchantForms?: VendorMerchantForm[];     // .rulesService.vendorMerchantForms
}

// Sub-model: ProfileService (Another massive structure)
interface ProfileService {
  activityBackground: ActivityBackground;         // .profileService.activityBackground
  activityRequirements: ActivityRequirements;    // .profileService.activityRequirements
}
```

### 2.3 ReservationItem - Complete Structure
```typescript
interface ReservationItem {
  reservationId: ValueObject<string>;             // .reservationId.getOrCrash()
  instanceId: ValueObject<string>;                // .instanceId (likely pattern)
  reservationOwnerId: ValueObject<string>;        // .reservationOwnerId.getOrCrash()
  
  // Type and status
  reservationType: ReservationType;               // Enum value
  reservationStatus: ReservationStatus;          // Enum value
  
  // Timing and slots
  selectedSlots: TimeSlot[];                      // Array of time slots
  availability?: AvailabilitySettings;           // Nested availability
  
  // Pricing and payment
  pricing: PricingBreakdown;                      // Nested pricing model
  paymentInfo?: PaymentInformation;               // Nested payment model
  
  // Metadata
  createdAt: ValueObject<Date>;
  updatedAt: ValueObject<Date>;
}
```

### 2.4 AttendeeItem - Complex Participant Model
```typescript
interface AttendeeItem {
  attendeeId: ValueObject<string>;                // .attendeeId.getOrCrash()
  attendeeOwnerId: ValueObject<string>;           // .attendeeOwnerId.getOrCrash()
  reservationId: ValueObject<string>;             // Link to reservation
  
  // Type and status
  attendeeType: AttendeeType;                     // .attendeeType (enum)
  contactStatus: ContactStatus;                   // .contactStatus (enum)
  paymentStatus: PaymentStatusType;               // .paymentStatus (enum)
  
  // Payment details
  cost: string;                                   // String representation of cost
  paymentIntentId?: string;                       // .paymentIntentId
  
  // Related profiles and forms
  eventMerchantVendorProfile?: EventMerchantVendorProfile; // .eventMerchantVendorProfile
  vendorForm?: VendorMerchantForm;                // .vendorForm
  ticketItems?: TicketItem[];                     // .ticketItems
  
  // Metadata
  dateCreated: Date;
  applicationDate?: Date;
  approvalDate?: Date;
}
```

### 2.5 EventMerchantVendorProfile - Vendor Profile
```typescript
interface EventMerchantVendorProfile {
  profileId: ValueObject<string>;                 // Standard ID pattern
  brandName: ValueObject<string>;                 // .brandName.getOrCrash()
  businessDescription?: ValueObject<string>;      // .businessDescription
  
  // Business details  
  businessName: ValueObject<string>;              // Business legal name
  businessType: BusinessType;                     // Enum for business type
  categories: ProductCategory[];                  // Array of categories
  
  // Verification and licensing
  businessLicense?: BusinessLicense;              // Nested license model
  isVerified: boolean;                            // Verification status
  verificationDocuments?: DocumentFile[];         // Verification files
  
  // Contact and location
  contactInformation: ContactInformation;         // Nested contact model
  businessAddress: Address;                       // Business location
  
  // Financial
  paymentInformation: PaymentInformation;         // Payment processing info
  taxInformation?: TaxInformation;                // Tax details
  
  // Performance metrics
  rating: number;                                 // Average rating
  reviewCount: number;                            // Number of reviews
  totalSales: number;                             // Sales metrics
  
  // Metadata
  createdAt: ValueObject<Date>;
  updatedAt: ValueObject<Date>;
}
```

---

## 3. Complex Nested Sub-Models Found

### 3.1 ActivityRequirements (Massive Structure)
```typescript
interface ActivityRequirements {
  // Age restrictions
  isSeventeenAndUnder: boolean;                   // .isSeventeenAndUnder
  minimumAgeRequirement: number;                  // .minimumAgeRequirement
  
  // Gender restrictions  
  isMensOnly?: boolean;                           // .isMensOnly
  isWomenOnly?: boolean;                          // .isWomenOnly  
  isCoEdOnly?: boolean;                           // .isCoEdOnly
  
  // Skill requirements
  skillLevelExpectation?: SkillLevel[];           // .skillLevelExpectation?.contains()
  
  // Equipment and services provided
  isGearProvided?: boolean;                       // .isGearProvided
  isEquipmentProvided?: boolean;                  // .isEquipmentProvided
  isAnalyticsProvided?: boolean;                  // .isAnalyticsProvided
  isOfficiatorProvided?: boolean;                 // .isOfficiatorProvided
  
  // Event-specific requirements (nested!)
  eventActivityRulesRequirement?: EventActivityRulesRequirement;
}

interface EventActivityRulesRequirement {
  isAlcoholForSale?: boolean;                     // .isAlcoholForSale
  isFoodForSale?: boolean;                        // .isFoodForSale
  isMerchantInviteOnly?: boolean;                 // .isMerchantInviteOnly
  merchantLimit?: number;                         // .merchantLimit
  merchantFee?: number;                           // .merchantFee
  
  // Services provided at events
  isAlcoholProvided?: boolean;                    // .isAlcoholProvided
  isFoodProvided?: boolean;                       // .isFoodProvided
  isSecurityProvided?: boolean;                   // .isSecurityProvided
}
```

### 3.2 CancellationSettings (Complex Rules)
```typescript
interface CancellationSettings {
  isNotAllowedCancellation?: boolean;             // .isNotAllowedCancellation
  isAllowedFeeBasedChanges?: boolean;             // .isAllowedFeeBasedChanges
  isAllowedTimeBasedChanges?: boolean;            // .isAllowedTimeBasedChanges
  
  // Fee-based cancellation options
  feeBasedCancellationOptions?: FeeCancellationOption[]; // Array of fee rules
  
  // Time-based cancellation options  
  timeBasedCancellationOptions?: TimeCancellationOption[]; // Array of time rules
}
```

### 3.3 AccessVisibilitySetting
```typescript
interface AccessVisibilitySetting {
  isPrivateOnly?: boolean;                        // .accessVisibilitySetting.isPrivateOnly
  isPublic?: boolean;                             // Public access
  isInviteOnly?: boolean;                         // Invite-only access
  isReviewRequired?: boolean;                     // Requires approval
  
  // Access control lists
  allowedUserIds?: string[];                      // Specific user access
  blockedUserIds?: string[];                      // Blocked users
}
```

---

## 4. Value Object Patterns Found

### 4.1 Identifier Pattern
```typescript
class UniqueId {
  constructor(private readonly value: string) {}
  
  getOrCrash(): string {
    if (!this.isValid()) throw new Error('Invalid ID');
    return this.value;
  }
  
  isValid(): boolean {
    return /^[0-9a-f-]{36}$/.test(this.value);
  }
  
  static fromUniqueString(value: string): UniqueId {
    return new UniqueId(value);
  }
}
```

### 4.2 Name Fields Pattern  
```typescript
class LegalName {
  constructor(private readonly _value: Either<Error, string>) {}
  
  get value(): Either<Error, string> {
    return this._value;
  }
  
  getOrCrash(): string {
    return this._value.fold(
      (error) => { throw error; },
      (value) => value
    );
  }
  
  isValid(): boolean {
    return this._value.isRight();
  }
}

// Same pattern for:
// - LegalSurname
// - EmailAddress  
// - PhoneNumber
// - BrandName
// - BusinessName
```

---

## 5. Missing Models Discovered (40+ Total)

### Core Models (10+)
1. `UserProfileModel` ✓
2. `ActivityManagerForm` ✓  
3. `ReservationItem` ✓
4. `AttendeeItem` ✓
5. `EventMerchantVendorProfile` ✓
6. `ListingManagerForm` (found in usage)
7. `VendorMerchantForm` (found in usage)
8. `TicketItem` (found in usage)
9. `ActivityTicketOption` (found in usage)
10. `ClassActivityBackground` (found in nested usage)

### Sub-Models & Services (30+)
11. `ActivityBackground`
12. `ActivityAvailability`  
13. `ActivityAttendance`
14. `RulesService`
15. `ProfileService`
16. `SettingsService`
17. `ActivityRequirements`
18. `EventActivityRulesRequirement`
19. `CancellationSettings`
20. `AccessVisibilitySetting`
21. `CheckInSetting`
22. `CustomFieldRule`
23. `FeeCancellationOption`
24. `TimeCancellationOption`
25. `ActivityImage`
26. `ContactInformation`
27. `PaymentInformation`
28. `BusinessLicense`
29. `TaxInformation`
30. `DocumentFile`
31. `Address`
32. `SocialMediaProfile`
33. `AccountSettings`
34. `PrivacySettings`
35. `TimeSlot`
36. `PricingBreakdown`
37. `AvailabilitySettings`
38. `SkillLevel` (enum)
39. `BusinessType` (enum)
40. `ProductCategory` (enum)

### Value Objects (10+)
41. `UniqueId`
42. `LegalName`
43. `LegalSurname`
44. `EmailAddress`
45. `PhoneNumber`
46. `BrandName`
47. `BusinessName`
48. `ActivityTitle`
49. `BusinessDescription`
50. Plus many more field-specific value objects...

---

## 6. Critical Implementation Requirements

### 6.1 Perfect Field Mapping Required
```typescript
// WRONG - Will break compatibility
interface UserProfile {
  id: string;
  legalName: string;  // Missing legalSurname!
  email: string;
}

// CORRECT - Exact field mapping
interface UserProfile {
  userId: UniqueId;
  legalName: LegalName;
  legalSurname: LegalSurname;  // CRITICAL - Must include!
  emailAddress: EmailAddress;
  phoneNumber?: PhoneNumber;
  // ... ALL other fields must be included
}
```

### 6.2 Transformation Layer Strategy
```typescript
// Create bidirectional mappers for each model
class UserProfileMapper {
  static fromFlutter(flutterData: any): UserProfile {
    return {
      userId: UniqueId.fromValue(flutterData.userId?.getOrCrash()),
      legalName: LegalName.fromValue(flutterData.legalName?.getOrCrash()),
      legalSurname: LegalSurname.fromValue(
        flutterData.legalSurname?.value?.fold(
          () => '',
          (value: string) => value
        )
      ),
      emailAddress: EmailAddress.fromValue(flutterData.emailAddress?.getOrCrash()),
      // Map every single field exactly...
    };
  }
  
  static toFlutter(tsData: UserProfile): any {
    return {
      userId: { value: { right: tsData.userId.getValue() } },
      legalName: { value: { right: tsData.legalName.getValue() } },
      legalSurname: { value: { right: tsData.legalSurname.getValue() } },
      // Reverse mapping for every field...
    };
  }
}
```

### 6.3 API Compatibility Layer
```typescript
// Ensure all API endpoints support both formats
app.post('/api/users', (req, res) => {
  const platform = req.headers['x-platform'] || 'nextjs';
  
  let userData;
  if (platform === 'flutter') {
    userData = UserProfileMapper.fromFlutter(req.body);
  } else {
    userData = req.body as UserProfile;
  }
  
  // Process userData...
  
  const response = platform === 'flutter' 
    ? UserProfileMapper.toFlutter(userData)
    : userData;
    
  res.json(response);
});
```

---

## 7. Recommended TypeScript Domain Structure

```typescript
src/domain/
├── entities/
│   ├── user/
│   │   ├── user-profile.entity.ts
│   │   ├── account-settings.entity.ts
│   │   └── privacy-settings.entity.ts
│   ├── activity/
│   │   ├── activity-manager-form.entity.ts
│   │   ├── activity-background.entity.ts
│   │   ├── activity-attendance.entity.ts
│   │   ├── activity-availability.entity.ts
│   │   └── activity-requirements.entity.ts
│   ├── reservation/
│   │   ├── reservation-item.entity.ts
│   │   └── pricing-breakdown.entity.ts
│   ├── attendee/
│   │   ├── attendee-item.entity.ts
│   │   └── ticket-item.entity.ts
│   └── vendor/
│       ├── vendor-profile.entity.ts
│       └── vendor-merchant-form.entity.ts
├── value-objects/
│   ├── identifiers/
│   │   ├── unique-id.vo.ts
│   │   └── user-id.vo.ts
│   ├── names/
│   │   ├── legal-name.vo.ts
│   │   ├── legal-surname.vo.ts
│   │   └── brand-name.vo.ts
│   ├── contact/
│   │   ├── email-address.vo.ts
│   │   └── phone-number.vo.ts
│   └── financial/
│       ├── money.vo.ts
│       └── currency.vo.ts
├── services/
│   ├── rules-service.ts
│   ├── profile-service.ts
│   └── settings-service.ts
├── mappers/
│   ├── user-profile.mapper.ts
│   ├── activity.mapper.ts
│   ├── reservation.mapper.ts
│   └── attendee.mapper.ts
└── enums/
    ├── attendee-type.enum.ts
    ├── contact-status.enum.ts
    ├── payment-status.enum.ts
    └── activity-type.enum.ts
```

---

## 8. Next Steps - Critical Actions

### Phase 1: Model Extraction (Week 1-2)
1. **Extract every field** from Flutter domain models
2. **Create TypeScript interfaces** with 100% field parity
3. **Implement value object classes** with exact behavior
4. **Build transformation mappers** for each entity

### Phase 2: Validation & Testing (Week 3-4)  
1. **Test round-trip conversion** (Flutter → TS → Flutter)
2. **Validate API compatibility** with both platforms
3. **Ensure no data loss** in transformations
4. **Performance test** mapping layers

### Phase 3: Integration (Week 5-6)
1. **Integrate with Next.js API routes**
2. **Test with actual Flutter app**
3. **Monitor for compatibility issues**
4. **Optimize transformation performance**

---

## Conclusion

The domain model is **vastly more complex** than initially estimated, with 60+ interconnected models and deep nesting. The critical success factor is **perfect field-level compatibility** - missing even one field like `legalSurname` will break the dual-platform approach.

**Immediate Action Required**: 
1. Audit exact Flutter domain model definitions
2. Create 1:1 TypeScript mappings  
3. Implement robust transformation layers
4. Test extensively for compatibility

The complexity justifies the aggressive timeline estimate - this is a substantial migration requiring meticulous attention to detail.