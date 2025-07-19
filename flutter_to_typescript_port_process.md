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
DateTime createdAt          → Date createdAt (JavaScript Date object)
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

### Step 6: Firebase Date Handling Strategy

#### 6.1 Firebase Date Storage Options
Firebase can store dates in multiple formats. We'll use **Timestamp** for optimal compatibility:

```typescript
// Firebase storage formats
// Option 1: Firestore Timestamp (RECOMMENDED)
import { Timestamp } from 'firebase/firestore';

// Option 2: ISO String (for simple compatibility)
// Option 3: JavaScript Date (converts to Timestamp automatically)
```

#### 6.2 TypeScript Model with Date Objects
```typescript
// TypeScript model uses native Date objects
export interface UserProfileModel {
  userId: string;
  legalName: string;
  legalSurname?: string;
  emailAddress: string;
  phoneNumber?: string;
  profileImageUrl?: string;
  dateOfBirth?: Date;                 // JavaScript Date object
  
  // Sub-models
  address?: Address;
  socialMediaProfiles: SocialMediaProfile[];
  accountSettings: AccountSettings;
  privacySettings: PrivacySettings;
  
  // Metadata as Date objects
  createdAt: Date;                    // JavaScript Date object
  updatedAt: Date;                    // JavaScript Date object
}
```

#### 6.3 Firebase Document Structure
When stored in Firebase, dates automatically convert to Firestore Timestamps:

```typescript
// What gets stored in Firebase (automatic conversion)
{
  "userId": "string-uuid",
  "legalName": "John",
  "legalSurname": "Doe",
  "emailAddress": "john@example.com",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://example.com/image.jpg",
  "dateOfBirth": Timestamp { seconds: 631152000, nanoseconds: 0 }, // Firebase Timestamp
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
  "createdAt": Timestamp { seconds: 1704067200, nanoseconds: 0 }, // Firebase Timestamp
  "updatedAt": Timestamp { seconds: 1704067200, nanoseconds: 0 }  // Firebase Timestamp
}
```

#### 6.4 Date Conversion Utilities
```typescript
// src/utils/date-conversion.utils.ts
import { Timestamp } from 'firebase/firestore';

export class DateConverter {
  // Convert Firebase Timestamp to JavaScript Date
  static timestampToDate(timestamp: Timestamp | string | Date): Date {
    if (timestamp instanceof Date) {
      return timestamp;
    }
    
    if (timestamp instanceof Timestamp) {
      return timestamp.toDate();
    }
    
    // Handle ISO string (legacy or from Flutter)
    if (typeof timestamp === 'string') {
      return new Date(timestamp);
    }
    
    throw new Error('Invalid timestamp format');
  }
  
  // Convert JavaScript Date to Firebase Timestamp
  static dateToTimestamp(date: Date): Timestamp {
    return Timestamp.fromDate(date);
  }
  
  // Convert Flutter DateTime ISO string to JavaScript Date
  static flutterDateTimeToDate(flutterDateTime: string): Date {
    return new Date(flutterDateTime);
  }
  
  // Convert JavaScript Date to Flutter-compatible ISO string
  static dateToFlutterDateTime(date: Date): string {
    return date.toISOString();
  }
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
  dateOfBirth: z.date().optional(),
  
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
  
  createdAt: z.date(),
  updatedAt: z.date(),
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
// Test Firebase read/write compatibility with Date objects
import { doc, getDoc, setDoc, Timestamp } from 'firebase/firestore';
import { DateConverter } from '@/utils/date-conversion.utils';

async function testFirebaseCompatibility() {
  const userData: UserProfileModel = {
    userId: "test-uuid",
    legalName: "John",
    legalSurname: "Doe",
    emailAddress: "john@example.com",
    phoneNumber: "+1234567890",
    dateOfBirth: new Date('1990-01-01'),    // JavaScript Date
    address: {
      street: "123 Main St",
      city: "City",
      state: "State",
      zipCode: "12345",
      country: "USA"
    },
    socialMediaProfiles: [],
    accountSettings: {
      notifications: true,
      privacy: 'public',
      language: 'en',
      timezone: 'America/New_York'
    },
    privacySettings: {
      showEmail: false,
      showPhone: false,
      showAddress: true
    },
    createdAt: new Date(),                  // JavaScript Date
    updatedAt: new Date()                   // JavaScript Date
  };
  
  // Write to Firebase (dates auto-convert to Timestamps)
  await setDoc(doc(db, 'users', userData.userId), userData);
  
  // Read from Firebase
  const docSnap = await getDoc(doc(db, 'users', userData.userId));
  const retrievedData = docSnap.data();
  
  // Convert Firebase Timestamps back to Date objects
  const convertedData = {
    ...retrievedData,
    dateOfBirth: retrievedData?.dateOfBirth ? 
      DateConverter.timestampToDate(retrievedData.dateOfBirth) : undefined,
    createdAt: DateConverter.timestampToDate(retrievedData?.createdAt),
    updatedAt: DateConverter.timestampToDate(retrievedData?.updatedAt)
  };
  
  // Validate converted data
  const validatedData = UserProfileModelSchema.parse(convertedData);
  console.log('Firebase Date compatibility verified ✅');
  
  // Verify date integrity
  console.log('Original createdAt:', userData.createdAt);
  console.log('Retrieved createdAt:', validatedData.createdAt);
  console.log('Dates match:', userData.createdAt.getTime() === validatedData.createdAt.getTime());
}
```

#### 8.3 Cross-Platform Date Flow Test
```typescript
// Verify Flutter ↔ TypeScript date compatibility
async function testCrossPlatformDateCompatibility() {
  // 1. TypeScript creates user data with Date objects
  const tsUserData: UserProfileModel = {
    userId: "ts-generated-uuid",
    legalName: "Jane",
    legalSurname: "Smith",
    emailAddress: "jane@example.com",
    dateOfBirth: new Date('1985-05-15'),    // TypeScript Date
    socialMediaProfiles: [],
    accountSettings: {
      notifications: true,
      privacy: 'private',
      language: 'en',
      timezone: 'America/Los_Angeles'
    },
    privacySettings: {
      showEmail: true,
      showPhone: false,
      showAddress: false
    },
    createdAt: new Date('2024-01-01T10:30:00Z'),  // TypeScript Date
    updatedAt: new Date()                         // TypeScript Date
  };
  
  // 2. Save to Firebase (auto-converts to Timestamps)
  await setDoc(doc(db, 'users', tsUserData.userId), tsUserData);
  
  // 3. Simulate Flutter reading the data
  const docSnap = await getDoc(doc(db, 'users', tsUserData.userId));
  const firebaseData = docSnap.data();
  
  // 4. Convert to Flutter-compatible ISO strings
  const flutterCompatibleData = {
    ...firebaseData,
    dateOfBirth: firebaseData?.dateOfBirth ? 
      DateConverter.dateToFlutterDateTime(DateConverter.timestampToDate(firebaseData.dateOfBirth)) : null,
    createdAt: DateConverter.dateToFlutterDateTime(DateConverter.timestampToDate(firebaseData?.createdAt)),
    updatedAt: DateConverter.dateToFlutterDateTime(DateConverter.timestampToDate(firebaseData?.updatedAt))
  };
  
  console.log('Flutter-compatible data:', flutterCompatibleData);
  
  // 5. Simulate Flutter writing data back as ISO strings
  const flutterGeneratedData = {
    userId: "flutter-generated-uuid",
    legalName: "Bob",
    emailAddress: "bob@example.com",
    dateOfBirth: "1992-12-25T00:00:00.000Z",  // Flutter DateTime.toIso8601String()
    socialMediaProfiles: [],
    accountSettings: {
      notifications: false,
      privacy: "public",
      language: "es",
      timezone: "Europe/Madrid"
    },
    privacySettings: {
      showEmail: false,
      showPhone: true,
      showAddress: false
    },
    createdAt: "2024-01-15T14:20:30.000Z",    // Flutter DateTime.toIso8601String()
    updatedAt: "2024-01-15T14:20:30.000Z"     // Flutter DateTime.toIso8601String()
  };
  
  // 6. Save Flutter data to Firebase
  await setDoc(doc(db, 'users', flutterGeneratedData.userId), flutterGeneratedData);
  
  // 7. TypeScript reads Flutter data and converts to Date objects
  const flutterDocSnap = await getDoc(doc(db, 'users', flutterGeneratedData.userId));
  const flutterFirebaseData = flutterDocSnap.data();
  
  const convertedFlutterData: UserProfileModel = {
    ...flutterFirebaseData,
    dateOfBirth: flutterFirebaseData?.dateOfBirth ? 
      DateConverter.flutterDateTimeToDate(flutterFirebaseData.dateOfBirth) : undefined,
    createdAt: DateConverter.flutterDateTimeToDate(flutterFirebaseData?.createdAt),
    updatedAt: DateConverter.flutterDateTimeToDate(flutterFirebaseData?.updatedAt)
  };
  
  // 8. Validate with Zod schema
  const validatedFlutterData = UserProfileModelSchema.parse(convertedFlutterData);
  
  console.log('Cross-platform Date compatibility verified ✅');
  console.log('TypeScript → Firebase → Flutter → Firebase → TypeScript: SUCCESS');
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
- [ ] `DateTime` → JavaScript `Date` object
- [ ] `bool` → `boolean`
- [ ] Enums → string literals
- [ ] Optional types properly handled

### ✅ **Firebase Compatibility**
- [ ] JSON structure is Firebase-friendly
- [ ] No complex nested objects that Firebase can't handle
- [ ] All field types are JSON-serializable
- [ ] Dates stored as Firebase Timestamps (auto-conversion from JS Date)
- [ ] Date conversion utilities handle Timestamp ↔ Date ↔ ISO string

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
- [ ] Date objects preserve exact time values across platforms
- [ ] Flutter DateTime ↔ TypeScript Date ↔ Firebase Timestamp conversion works flawlessly

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
    ├── date-conversion.utils.ts         # Date conversion utilities
    ├── flutter-compatibility.test.ts   # Compatibility tests
    └── firebase-compatibility.test.ts  # Firebase integration tests
```

---

## Summary

This process ensures **exact compatibility** between Flutter and TypeScript models while leveraging TypeScript's simplicity and Firebase's JSON structure. The key is maintaining the **exact field structure** from `stefanmiller/check_in_domain` while transforming complex Flutter value objects into simple TypeScript types that work seamlessly with Firebase.

**Next Model**: Apply this same process to `ReservationItem`, `AttendeeItem`, etc., following these exact steps for each model port.