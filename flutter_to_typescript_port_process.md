# Flutter to TypeScript Domain Model Port Process
## Step-by-Step Guide for Exact Model Compatibility

### Overview
This document outlines the **exact process** for porting Flutter domain models from `stefanmiller/check_in_domain` to TypeScript while maintaining 100% field compatibility and Firebase JSON structure compatibility.

---

## Port Process Rules

### 🔒 **Non-Negotiable Rules**
1. **Source**: All backend models live in `stefanmiller/check_in_domain`
2. **Naming**: Do NOT change the naming of any existing models
3. **Fields**: Capture every single value within the model
4. **Structure**: Create sub-models contained within the primary model
5. **Storage**: Firebase-friendly JSON structure
6. **Verification**: TS compatibility check with Firebase and existing Flutter model

---

## Step-by-Step Port Process

### Step 1: Locate Source Model
```bash
# Source location
stefanmiller/check_in_domain/lib/models/user_profile_model.dart
```

### Step 2: Analyze Flutter Model Structure
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

### Step 3: Identify Value Objects vs Simple Fields
Map Flutter value objects to TypeScript simple types:

```typescript
// Flutter Value Object → TypeScript Simple Type
UserId userId               → string userId
LegalName legalName         → string legalName  
LegalSurname? legalSurname  → string? legalSurname
EmailAddress emailAddress  → string emailAddress
PhoneNumber? phoneNumber    → string? phoneNumber
DateTime createdAt          → string createdAt (ISO string)
```

### Step 4: Create TypeScript Interface (Exact Naming)
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
  dateOfBirth?: string;               // DateOfBirth? → optional ISO string
  
  // Sub-models (nested objects - exact names)
  address?: Address;                  // Address? → optional nested object
  socialMediaProfiles: SocialMediaProfile[];  // List<SocialMediaProfile> → array
  accountSettings: AccountSettings;   // AccountSettings → nested object
  privacySettings: PrivacySettings;   // PrivacySettings → nested object
  
  // Metadata (Firebase compatible)
  createdAt: string;                  // DateTime → ISO string
  updatedAt: string;                  // DateTime → ISO string
}
```

### Step 5: Create Sub-Models (Exact Structure)
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

// Sub-model: SocialMediaProfile
export interface SocialMediaProfile {
  platform: string;                  // Exact field from Flutter
  username: string;
  url?: string;
}

// Sub-model: AccountSettings
export interface AccountSettings {
  notifications: boolean;             // Flutter bool → TypeScript boolean
  privacy: 'public' | 'private' | 'friends';  // Flutter enum → string literal
  language: string;
  timezone: string;
}

// Sub-model: PrivacySettings
export interface PrivacySettings {
  showEmail: boolean;                 // Flutter bool → TypeScript boolean
  showPhone: boolean;
  showAddress: boolean;
}
```

### Step 6: Firebase JSON Structure Verification
Ensure the TypeScript model produces Firebase-compatible JSON:

```json
{
  "userId": "string-uuid",
  "legalName": "John",
  "legalSurname": "Doe",
  "emailAddress": "john@example.com",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://example.com/image.jpg",
  "dateOfBirth": "1990-01-01T00:00:00.000Z",
  "address": {
    "street": "123 Main St",
    "city": "City",
    "state": "State",
    "zipCode": "12345",
    "country": "USA",
    "coordinates": {
      "latitude": 40.7128,
      "longitude": -74.0060
    }
  },
  "socialMediaProfiles": [
    {
      "platform": "instagram",
      "username": "johndoe",
      "url": "https://instagram.com/johndoe"
    }
  ],
  "accountSettings": {
    "notifications": true,
    "privacy": "public",
    "language": "en",
    "timezone": "America/New_York"
  },
  "privacySettings": {
    "showEmail": false,
    "showPhone": false,
    "showAddress": true
  },
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

### Step 7: Create Zod Validation Schema
```typescript
// src/domain/schemas/user-profile.schema.ts
import { z } from 'zod';

// Zod schema matching EXACT TypeScript interface
export const UserProfileModelSchema = z.object({
  userId: z.string().uuid(),
  legalName: z.string().min(1).max(100),
  legalSurname: z.string().max(100).optional(),
  emailAddress: z.string().email(),
  phoneNumber: z.string().optional(),
  profileImageUrl: z.string().url().optional(),
  dateOfBirth: z.string().datetime().optional(),
  
  // Sub-model validation
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

// Type inference from Zod schema
export type UserProfileModel = z.infer<typeof UserProfileModelSchema>;
```

### Step 8: Compatibility Verification

#### 8.1 Flutter → TypeScript Compatibility Check
```typescript
// src/utils/flutter-compatibility.test.ts
import { UserProfileModelSchema } from '@/domain/schemas/user-profile.schema';

// Test with Flutter-generated JSON
const flutterUserData = {
  userId: "flutter-generated-uuid",
  legalName: "John",  // From LegalName.getOrCrash()
  legalSurname: "Doe", // From LegalSurname.value.fold()
  emailAddress: "john@example.com", // From EmailAddress.getOrCrash()
  // ... rest of Flutter data
};

// Verify Zod validation passes
test('Flutter data validates with TypeScript schema', () => {
  const result = UserProfileModelSchema.safeParse(flutterUserData);
  expect(result.success).toBe(true);
});
```

#### 8.2 Firebase Compatibility Check
```typescript
// Test Firebase read/write compatibility
import { doc, getDoc, setDoc } from 'firebase/firestore';

async function testFirebaseCompatibility() {
  const userData: UserProfileModel = {
    userId: "test-uuid",
    legalName: "John",
    // ... complete user data
  };
  
  // Write to Firebase
  await setDoc(doc(db, 'users', userData.userId), userData);
  
  // Read from Firebase
  const docSnap = await getDoc(doc(db, 'users', userData.userId));
  const retrievedData = docSnap.data();
  
  // Validate retrieved data
  const validatedData = UserProfileModelSchema.parse(retrievedData);
  console.log('Firebase compatibility verified ✅');
}
```

#### 8.3 Cross-Platform Data Flow Test
```typescript
// Verify Flutter app can read TypeScript-generated data
async function testCrossPlatformCompatibility() {
  // 1. TypeScript creates user data
  const tsUserData: UserProfileModel = {
    userId: "ts-generated-uuid",
    legalName: "Jane",
    legalSurname: "Smith",
    emailAddress: "jane@example.com",
    // ... complete data
  };
  
  // 2. Save to Firebase
  await setDoc(doc(db, 'users', tsUserData.userId), tsUserData);
  
  // 3. Flutter app should be able to read this data
  // 4. Flutter UserProfileModel.fromJson() should work correctly
  
  console.log('Cross-platform compatibility verified ✅');
}
```

---

## Verification Checklist

### ✅ **Model Structure Verification**
- [ ] Exact model name preserved (`UserProfileModel`)
- [ ] Every Flutter field captured in TypeScript
- [ ] Sub-models created for nested objects
- [ ] Optional fields properly marked with `?`
- [ ] Array types correctly mapped from `List<T>`

### ✅ **Type Mapping Verification**
- [ ] Flutter value objects → TypeScript simple types
- [ ] `DateTime` → ISO string
- [ ] `bool` → `boolean`
- [ ] Enums → string literals
- [ ] Optional types properly handled

### ✅ **Firebase Compatibility**
- [ ] JSON structure is Firebase-friendly
- [ ] No complex nested objects that Firebase can't handle
- [ ] All field types are JSON-serializable
- [ ] Dates stored as ISO strings

### ✅ **Validation Integration**
- [ ] Zod schema matches TypeScript interface exactly
- [ ] All validations appropriate for field types
- [ ] Runtime type safety for API boundaries
- [ ] Error handling for invalid data

### ✅ **Cross-Platform Compatibility**
- [ ] Flutter app can read TypeScript-generated data
- [ ] TypeScript app can read Flutter-generated data
- [ ] No data loss in round-trip conversion
- [ ] Field names match exactly across platforms

---

## File Organization

```
src/domain/
├── entities/
│   └── user-profile.entity.ts          # UserProfileModel interface
├── schemas/
│   └── user-profile.schema.ts          # Zod validation schema
├── types/
│   └── common.types.ts                 # Shared sub-interfaces
└── utils/
    ├── flutter-compatibility.test.ts   # Compatibility tests
    └── firebase-compatibility.test.ts  # Firebase integration tests
```

---

## Summary

This process ensures **exact compatibility** between Flutter and TypeScript models while leveraging TypeScript's simplicity and Firebase's JSON structure. The key is maintaining the **exact field structure** from `stefanmiller/check_in_domain` while transforming complex Flutter value objects into simple TypeScript types that work seamlessly with Firebase.

**Next Model**: Apply this same process to `ReservationItem`, `AttendeeItem`, etc., following these exact steps for each model port.