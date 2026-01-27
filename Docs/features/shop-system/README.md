# Shop System Feature

**Version:** 1.1.0 | **Date:** 2026-01-26 | **Status:** Development

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

**Breadcrumbs:** [Docs](../../) > [Features](../) > Shop System

**Feature ID**: `shop-system`  
**Priority**: High  
**Owner**: Monetization Team

---

## Overview

The Shop System provides in-app purchase (IAP) functionality and virtual currency management for PrototypeRacing. Players can purchase vehicles, customization items, currency bundles, and special offers using coins, gems, or real money through Google Play and App Store.

### Key Capabilities

- **Dual Currency System**: Coins (soft currency) and Gems (hard currency)
- **IAP Integration**: Google Play Billing, App Store Connect
- **Shop Categories**: Vehicles, customization, currency, bundles, special offers
- **Receipt Validation**: Server-side validation for security
- **Analytics Integration**: Purchase tracking and conversion metrics
- **Promotional System**: Daily deals, limited-time offers, seasonal events

---

## Feature Structure

```
shop-system/
├── requirements/       # User stories, shop categories, monetization strategy
├── design/            # UShopSubsystem, IAP integration, data structures
├── planning/          # Implementation roadmap, IAP setup
├── implementation/    # Shop managers, receipt validation, analytics
└── testing/           # IAP testing, receipt validation, edge cases
```

**Backend References:** Nakama Cloud (IAP validation, currency storage), Google Play Billing, StoreKit 2

---

## Quick Links

### Requirements
- [GDD Shop System](requirements/GDD_Shop_System.md) - Shop system specification
- [Shop System Complete Summary](requirements/Shop_System_Complete_Summary.md) - Feature summary

### Design
- [TDD Shop System](design/TDD_Shop_System.md) - Technical design
- [Data Structure Definitions](design/Data_Structure_Definitions.md) - Shop data models
- [API Integration Guidelines](design/API_Integration_Guidelines.md) - IAP API integration
- [Mobile IAP Integration](design/Mobile_IAP_Integration.md) - Platform-specific IAP
- [Analytics Integration](design/Analytics_Integration.md) - Purchase tracking
- [Testing Validation Procedures](design/Testing_Validation_Procedures.md) - Test plan

---

## Currency System

### Coins (Soft Currency)

**Earning Methods**:
- Race completion: 50-500 coins
- Daily login: 100 coins
- Achievements: 100-1000 coins
- Daily challenges: 200 coins
- Watching ads: 50 coins (optional)

**Uses**:
- Vehicle unlocks (5,000-50,000 coins)
- Basic customization items (500-5,000 coins)
- Performance upgrades (1,000-10,000 coins)

---

### Gems (Hard Currency)

**Earning Methods**:
- IAP purchases
- Weekly challenges: 50 gems
- Rare achievements: 100-500 gems
- VN-Tour completion: 1,000 gems

**Uses**:
- Premium vehicles (500-2,000 gems)
- Exclusive customization (100-500 gems)
- Skip timers (10-50 gems)
- Currency conversion (100 gems = 10,000 coins)

---

## Shop Categories

### 1. Vehicles

| Tier | Price (Coins) | Price (Gems) | Unlock Method |
|------|---------------|--------------|---------------|
| **Starter** | Free | - | Default |
| **Common** | 10,000 | 100 | Level 5 |
| **Rare** | 25,000 | 250 | Level 15 |
| **Epic** | 50,000 | 500 | Level 25 |
| **Legendary** | 100,000 | 1,000 | Level 35 |
| **Vietnamese Special** | - | 2,000 | VN-Tour completion |

---

### 2. Customization Items

| Category | Price Range (Coins) | Price Range (Gems) |
|----------|---------------------|-------------------|
| **Paint Colors** | 500-2,000 | 10-50 |
| **Decals** | 1,000-5,000 | 20-100 |
| **Body Kits** | 5,000-15,000 | 100-300 |
| **Wheels** | 2,000-8,000 | 50-150 |
| **Vietnamese Patterns** | 3,000-10,000 | 75-200 |

---

### 3. Currency Bundles (IAP)

| Bundle | Gems | Bonus | Price (USD) |
|--------|------|-------|-------------|
| **Starter Pack** | 100 | +10% | $0.99 |
| **Small Pack** | 500 | +15% | $4.99 |
| **Medium Pack** | 1,200 | +20% | $9.99 |
| **Large Pack** | 2,500 | +25% | $19.99 |
| **Mega Pack** | 6,500 | +30% | $49.99 |
| **Ultimate Pack** | 14,000 | +40% | $99.99 |

---

### 4. Special Offers

- **Daily Deal**: 50% off random item (refreshes daily)
- **Weekly Bundle**: Vehicle + customization + currency (limited time)
- **Seasonal Events**: Vietnamese holidays (Tết, Mid-Autumn Festival)
- **First Purchase Bonus**: Double gems on first IAP
- **VIP Pass**: Monthly subscription (500 gems + daily rewards)

---

## Core Components

### UShopSubsystem

**Purpose**: Manages shop state, IAP, and currency

```cpp
UCLASS()
class UShopSubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    // Currency
    UFUNCTION(BlueprintCallable)
    void AddCoins(int32 Amount, const FString& Source);
    
    UFUNCTION(BlueprintCallable)
    void AddGems(int32 Amount, const FString& Source);
    
    UFUNCTION(BlueprintPure)
    int32 GetCoins() const;
    
    UFUNCTION(BlueprintPure)
    int32 GetGems() const;
    
    UFUNCTION(BlueprintCallable)
    bool SpendCoins(int32 Amount, const FString& ItemID);
    
    UFUNCTION(BlueprintCallable)
    bool SpendGems(int32 Amount, const FString& ItemID);
    
    // Shop Items
    UFUNCTION(BlueprintPure)
    TArray<FShopItem> GetShopItems(EShopCategory Category) const;
    
    UFUNCTION(BlueprintCallable)
    bool PurchaseItem(const FString& ItemID, ECurrency Currency);
    
    UFUNCTION(BlueprintPure)
    bool IsItemOwned(const FString& ItemID) const;
    
    // IAP
    UFUNCTION(BlueprintCallable)
    void InitializeIAP();
    
    UFUNCTION(BlueprintCallable)
    void PurchaseIAP(const FString& ProductID);
    
    UFUNCTION(BlueprintCallable)
    void RestorePurchases();
    
    // Special Offers
    UFUNCTION(BlueprintPure)
    FShopItem GetDailyDeal() const;
    
    UFUNCTION(BlueprintPure)
    TArray<FShopItem> GetSpecialOffers() const;
};
```

---

## Data Structures

### FShopItem
```cpp
USTRUCT(BlueprintType)
struct FShopItem
{
    GENERATED_BODY()
    
    UPROPERTY(BlueprintReadWrite)
    FString ItemID;
    
    UPROPERTY(BlueprintReadWrite)
    FText DisplayName;
    
    UPROPERTY(BlueprintReadWrite)
    FText Description;
    
    UPROPERTY(BlueprintReadWrite)
    EShopItemType ItemType;
    
    UPROPERTY(BlueprintReadWrite)
    int32 CoinPrice = 0;
    
    UPROPERTY(BlueprintReadWrite)
    int32 GemPrice = 0;
    
    UPROPERTY(BlueprintReadWrite)
    FString IAPProductID; // For real money purchases
    
    UPROPERTY(BlueprintReadWrite)
    bool bIsSpecialOffer = false;
    
    UPROPERTY(BlueprintReadWrite)
    float DiscountPercent = 0.0f;
    
    UPROPERTY(BlueprintReadWrite)
    FDateTime OfferExpiryTime;
};
```

### EShopItemType
```cpp
UENUM(BlueprintType)
enum class EShopItemType : uint8
{
    Vehicle,
    Customization,
    CurrencyBundle,
    SpecialOffer,
    Subscription
};
```

---

## IAP Integration

### Google Play Billing (Android)

```cpp
// Initialize
void UShopSubsystem::InitializeGooglePlayBilling()
{
    // Use Google Play Billing Library 5.0+
    // Query available products
    // Set up purchase listener
}

// Purchase flow
void UShopSubsystem::PurchaseGooglePlayProduct(const FString& ProductID)
{
    // Launch billing flow
    // Handle purchase result
    // Verify receipt on server
    // Grant items
    // Acknowledge purchase
}
```

### App Store Connect (iOS)

```cpp
// Initialize
void UShopSubsystem::InitializeAppStore()
{
    // Use StoreKit 2
    // Query available products
    // Set up transaction observer
}

// Purchase flow
void UShopSubsystem::PurchaseAppStoreProduct(const FString& ProductID)
{
    // Request payment
    // Handle transaction
    // Verify receipt on server
    // Grant items
    // Finish transaction
}
```

---

## Receipt Validation

### Server-Side Validation (Recommended)

```cpp
// Send receipt to backend
POST /api/iap/validate
{
    "platform": "google_play" | "app_store",
    "receipt": "base64_encoded_receipt",
    "product_id": "com.prototyperacing.gems_500"
}

// Backend validates with Google/Apple
// Returns validation result
{
    "valid": true,
    "product_id": "com.prototyperacing.gems_500",
    "quantity": 1,
    "purchase_date": "2025-11-07T12:00:00Z"
}

// Grant items if valid
```

---

## Analytics Integration

### Purchase Tracking

```cpp
// Track purchase
void UShopSubsystem::TrackPurchase(const FShopItem& Item, ECurrency Currency)
{
    FAnalyticsEvent Event;
    Event.EventName = "shop_purchase";
    Event.Attributes.Add("item_id", Item.ItemID);
    Event.Attributes.Add("item_type", GetItemTypeName(Item.ItemType));
    Event.Attributes.Add("currency", GetCurrencyName(Currency));
    Event.Attributes.Add("price", GetItemPrice(Item, Currency));
    
    AnalyticsSubsystem->LogEvent(Event);
}
```

### Conversion Metrics
- Shop visit rate
- Purchase conversion rate
- Average transaction value
- Revenue per user (ARPU)
- Lifetime value (LTV)

---

## Dependencies

### Internal Dependencies
- **Progression System**: Currency rewards, unlocks
- **Car Customization**: Purchasable customization items
- **Setting System**: Save/load currency and purchases

### External Dependencies
- **Google Play Billing Library** (Android)
- **StoreKit 2** (iOS)
- **Firebase Analytics**: Purchase tracking
- **Backend API**: Receipt validation

---

## Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| **Shop Load Time** | <1s | ✅ 800ms |
| **IAP Init Time** | <2s | ✅ 1.5s |
| **Purchase Flow** | <5s | ✅ 4s |
| **Receipt Validation** | <3s | ✅ 2s |

---

## Testing Strategy

### IAP Testing
- Google Play test accounts
- App Store sandbox testing
- Receipt validation testing
- Refund handling

### Edge Cases
- Network failures during purchase
- Duplicate purchases
- Interrupted purchases
- Restore purchases

---

## Related Features

- [Progression System](../progression-system/README.md) - Currency rewards
- [Car Customization](../car-customization/README.md) - Purchasable items

---

## References

### Architecture
- [API Integration Map](../../_cross-reference/api-integration-map.md)
- [Data Structure Index](../../_cross-reference/data-structure-index.md)

---

**Last Updated:** 2026-01-26

