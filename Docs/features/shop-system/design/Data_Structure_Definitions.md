# Data Structure Definitions - Shop System

**Project**: PrototypeRacing  
**Document**: Shop System Data Structure Definitions  
**Version**: 1.0  
**Date**: 2025-09-07  
**Status**: Implementation Ready

## 🏗️ **Core Shop Data Structures**

### Shop Item Definition
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FShopItem
{
    GENERATED_BODY()

    // Basic item information
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Basic Info")
    FName ItemId;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Basic Info")
    FText DisplayName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Basic Info")
    FText Description;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Basic Info")
    FText ShortDescription;
    
    // Categorization
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Category")
    EShopCategory Category;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Category")
    EShopSubCategory SubCategory;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Category")
    TArray<FName> Tags;
    
    // Pricing information
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Pricing")
    TMap<ECurrencyType, int32> Prices;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Pricing")
    EPurchaseType PurchaseType;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Pricing")
    FString PlatformProductId; // For real money purchases
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Pricing")
    bool bHasDiscount = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Pricing")
    float DiscountPercentage = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Pricing")
    FDateTime DiscountEndTime;
    
    // Visual assets
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    TSoftObjectPtr<UTexture2D> Icon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    TSoftObjectPtr<UTexture2D> PreviewImage;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    TSoftObjectPtr<UStaticMesh> PreviewMesh;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Visual")
    TArray<TSoftObjectPtr<UTexture2D>> GalleryImages;
    
    // Availability and restrictions
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Availability")
    bool bIsAvailable = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Availability")
    bool bIsLimitedTime = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Availability")
    FDateTime AvailableFrom;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Availability")
    FDateTime AvailableUntil;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Availability")
    int32 MaxQuantity = -1; // -1 = unlimited
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Availability")
    int32 MaxPurchasesPerPlayer = -1; // -1 = unlimited
    
    // Requirements and unlocks
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirements")
    TArray<FShopItemRequirement> Requirements;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirements")
    TArray<FName> PrerequisiteItems;
    
    // Display and sorting
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    bool bIsFeatured = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    bool bIsNew = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    bool bIsPopular = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    int32 SortOrder = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    EItemRarity Rarity = EItemRarity::Common;
    
    // Item content and rewards
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
    TArray<FItemReward> ItemRewards;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Content")
    TMap<FString, FString> ItemProperties;
    
    // Metadata
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Metadata")
    FDateTime CreatedTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Metadata")
    FDateTime LastModifiedTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Metadata")
    FString CreatedBy;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Metadata")
    int32 Version = 1;
    
    // Validation and utility functions
    UFUNCTION(BlueprintPure, Category = "Shop Item")
    bool IsValid() const;
    
    UFUNCTION(BlueprintPure, Category = "Shop Item")
    bool IsAvailableNow() const;
    
    UFUNCTION(BlueprintPure, Category = "Shop Item")
    bool MeetsRequirements(const FPlayerProgressionData& PlayerData) const;
    
    UFUNCTION(BlueprintPure, Category = "Shop Item")
    int32 GetEffectivePrice(ECurrencyType CurrencyType) const;
    
    UFUNCTION(BlueprintPure, Category = "Shop Item")
    FText GetDisplayPrice(ECurrencyType CurrencyType) const;
    
    // Operators
    bool operator==(const FShopItem& Other) const;
    bool operator!=(const FShopItem& Other) const;
};

// Enums for shop item categorization
UENUM(BlueprintType)
enum class EShopCategory : uint8
{
    Cars = 0 UMETA(DisplayName = "Cars"),
    CarParts = 1 UMETA(DisplayName = "Car Parts"),
    Customization = 2 UMETA(DisplayName = "Customization"),
    CurrencyPacks = 3 UMETA(DisplayName = "Currency Packs"),
    PremiumFeatures = 4 UMETA(DisplayName = "Premium Features"),
    Bundles = 5 UMETA(DisplayName = "Bundles"),
    Seasonal = 6 UMETA(DisplayName = "Seasonal"),
    Special = 7 UMETA(DisplayName = "Special")
};

UENUM(BlueprintType)
enum class EShopSubCategory : uint8
{
    // Cars subcategories
    SportsCars = 0 UMETA(DisplayName = "Sports Cars"),
    OffroadCars = 1 UMETA(DisplayName = "Offroad Cars"),
    ClassicCars = 2 UMETA(DisplayName = "Classic Cars"),
    
    // Car Parts subcategories
    Engine = 10 UMETA(DisplayName = "Engine"),
    Wheels = 11 UMETA(DisplayName = "Wheels"),
    Suspension = 12 UMETA(DisplayName = "Suspension"),
    Brakes = 13 UMETA(DisplayName = "Brakes"),
    Exhaust = 14 UMETA(DisplayName = "Exhaust"),
    
    // Customization subcategories
    PaintJobs = 20 UMETA(DisplayName = "Paint Jobs"),
    Decals = 21 UMETA(DisplayName = "Decals"),
    Accessories = 22 UMETA(DisplayName = "Accessories"),
    InteriorCustomization = 23 UMETA(DisplayName = "Interior"),
    
    // Currency subcategories
    CoinPacks = 30 UMETA(DisplayName = "Coin Packs"),
    GemPacks = 31 UMETA(DisplayName = "Gem Packs"),
    
    // Premium subcategories
    BattlePass = 40 UMETA(DisplayName = "Battle Pass"),
    VIPMembership = 41 UMETA(DisplayName = "VIP Membership"),
    
    // Bundle subcategories
    StarterPacks = 50 UMETA(DisplayName = "Starter Packs"),
    CarBundles = 51 UMETA(DisplayName = "Car Bundles"),
    ThemeBundles = 52 UMETA(DisplayName = "Theme Bundles"),
    
    // Seasonal subcategories
    HolidayItems = 60 UMETA(DisplayName = "Holiday Items"),
    VNTourSpecial = 61 UMETA(DisplayName = "VN-Tour Special"),
    LimitedEdition = 62 UMETA(DisplayName = "Limited Edition")
};

UENUM(BlueprintType)
enum class EPurchaseType : uint8
{
    InGameCurrency = 0 UMETA(DisplayName = "In-Game Currency"),
    RealMoney = 1 UMETA(DisplayName = "Real Money"),
    Achievement = 2 UMETA(DisplayName = "Achievement Unlock"),
    Progression = 3 UMETA(DisplayName = "Progression Unlock"),
    Free = 4 UMETA(DisplayName = "Free"),
    Subscription = 5 UMETA(DisplayName = "Subscription")
};

UENUM(BlueprintType)
enum class EItemRarity : uint8
{
    Common = 0 UMETA(DisplayName = "Common"),
    Uncommon = 1 UMETA(DisplayName = "Uncommon"),
    Rare = 2 UMETA(DisplayName = "Rare"),
    Epic = 3 UMETA(DisplayName = "Epic"),
    Legendary = 4 UMETA(DisplayName = "Legendary"),
    Mythic = 5 UMETA(DisplayName = "Mythic")
};
```

### Shop Item Requirements
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FShopItemRequirement
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirement")
    ERequirementType Type;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirement")
    FString Parameter;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirement")
    int32 Value;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirement")
    EComparisonOperator Operator = EComparisonOperator::GreaterOrEqual;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirement")
    FText DisplayText;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Requirement")
    bool bIsOptional = false;
    
    // Validation
    UFUNCTION(BlueprintPure, Category = "Requirement")
    bool IsMetBy(const FPlayerProgressionData& PlayerData) const;
    
    UFUNCTION(BlueprintPure, Category = "Requirement")
    FText GetRequirementDescription() const;
};

UENUM(BlueprintType)
enum class ERequirementType : uint8
{
    PlayerLevel = 0 UMETA(DisplayName = "Player Level"),
    Achievement = 1 UMETA(DisplayName = "Achievement"),
    VNTourProgress = 2 UMETA(DisplayName = "VN-Tour Progress"),
    SeasonalTier = 3 UMETA(DisplayName = "Seasonal Tier"),
    CarOwnership = 4 UMETA(DisplayName = "Car Ownership"),
    PremiumPass = 5 UMETA(DisplayName = "Premium Pass"),
    Currency = 6 UMETA(DisplayName = "Currency Amount"),
    RaceWins = 7 UMETA(DisplayName = "Race Wins"),
    TotalDistance = 8 UMETA(DisplayName = "Total Distance"),
    TimeSpent = 9 UMETA(DisplayName = "Time Spent"),
    ItemOwnership = 10 UMETA(DisplayName = "Item Ownership")
};

UENUM(BlueprintType)
enum class EComparisonOperator : uint8
{
    Equal = 0 UMETA(DisplayName = "Equal"),
    GreaterThan = 1 UMETA(DisplayName = "Greater Than"),
    GreaterOrEqual = 2 UMETA(DisplayName = "Greater Or Equal"),
    LessThan = 3 UMETA(DisplayName = "Less Than"),
    LessOrEqual = 4 UMETA(DisplayName = "Less Or Equal"),
    NotEqual = 5 UMETA(DisplayName = "Not Equal")
};
```

### Item Rewards and Content
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FItemReward
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Reward")
    ERewardType RewardType;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Reward")
    FName RewardId;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Reward")
    int32 Quantity = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Reward")
    FText DisplayName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Reward")
    TSoftObjectPtr<UTexture2D> Icon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Reward")
    TMap<FString, FString> Properties;
    
    // Validation
    UFUNCTION(BlueprintPure, Category = "Reward")
    bool IsValid() const;
    
    UFUNCTION(BlueprintPure, Category = "Reward")
    FText GetDisplayText() const;
};

UENUM(BlueprintType)
enum class ERewardType : uint8
{
    Currency = 0 UMETA(DisplayName = "Currency"),
    Car = 1 UMETA(DisplayName = "Car"),
    CarPart = 2 UMETA(DisplayName = "Car Part"),
    Customization = 3 UMETA(DisplayName = "Customization"),
    XP = 4 UMETA(DisplayName = "Experience Points"),
    Achievement = 5 UMETA(DisplayName = "Achievement"),
    Title = 6 UMETA(DisplayName = "Title"),
    Avatar = 7 UMETA(DisplayName = "Avatar"),
    Emote = 8 UMETA(DisplayName = "Emote"),
    Bundle = 9 UMETA(DisplayName = "Bundle"),
    Subscription = 10 UMETA(DisplayName = "Subscription")
};
```

## 💰 **Currency and Transaction Data**

### Currency System
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FCurrencyData
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Currency")
    TMap<ECurrencyType, int32> CurrencyAmounts;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Currency")
    TMap<ECurrencyType, FDateTime> LastEarnedTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Currency")
    TMap<ECurrencyType, int32> TotalEarned;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Currency")
    TMap<ECurrencyType, int32> TotalSpent;
    
    // Currency operations
    UFUNCTION(BlueprintCallable, Category = "Currency")
    bool SpendCurrency(ECurrencyType CurrencyType, int32 Amount);
    
    UFUNCTION(BlueprintCallable, Category = "Currency")
    void AddCurrency(ECurrencyType CurrencyType, int32 Amount, ECurrencySource Source);
    
    UFUNCTION(BlueprintPure, Category = "Currency")
    int32 GetCurrencyAmount(ECurrencyType CurrencyType) const;
    
    UFUNCTION(BlueprintPure, Category = "Currency")
    bool HasEnoughCurrency(ECurrencyType CurrencyType, int32 Amount) const;
    
    // Validation
    void ValidateCurrencyAmounts();
    void RepairCorruptedData();
};

UENUM(BlueprintType)
enum class ECurrencyType : uint8
{
    Coins = 0 UMETA(DisplayName = "Coins"),
    Gems = 1 UMETA(DisplayName = "Gems"),
    SeasonalTokens = 2 UMETA(DisplayName = "Seasonal Tokens"),
    ClubPoints = 3 UMETA(DisplayName = "Club Points"),
    VIPPoints = 4 UMETA(DisplayName = "VIP Points")
};

UENUM(BlueprintType)
enum class ECurrencySource : uint8
{
    Purchase = 0 UMETA(DisplayName = "Purchase"),
    RaceReward = 1 UMETA(DisplayName = "Race Reward"),
    Achievement = 2 UMETA(DisplayName = "Achievement"),
    DailyLogin = 3 UMETA(DisplayName = "Daily Login"),
    Seasonal = 4 UMETA(DisplayName = "Seasonal"),
    VIPBonus = 5 UMETA(DisplayName = "VIP Bonus"),
    Admin = 6 UMETA(DisplayName = "Admin Grant"),
    Refund = 7 UMETA(DisplayName = "Refund")
};
```

### Transaction Data
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FTransactionData
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FString TransactionId;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FName ItemId;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    int32 Quantity;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    EPurchaseType PurchaseType;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    TMap<ECurrencyType, int32> CurrencySpent;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    float RealMoneySpent;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FString CurrencyCode;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FDateTime TransactionTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    ETransactionStatus Status;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FString PlatformTransactionId;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FString ReceiptData;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    bool bIsValidated = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Transaction")
    FString ValidationError;
    
    // Validation
    UFUNCTION(BlueprintPure, Category = "Transaction")
    bool IsValid() const;
    
    UFUNCTION(BlueprintPure, Category = "Transaction")
    FText GetStatusText() const;
};

UENUM(BlueprintType)
enum class ETransactionStatus : uint8
{
    Pending = 0 UMETA(DisplayName = "Pending"),
    Processing = 1 UMETA(DisplayName = "Processing"),
    Completed = 2 UMETA(DisplayName = "Completed"),
    Failed = 3 UMETA(DisplayName = "Failed"),
    Cancelled = 4 UMETA(DisplayName = "Cancelled"),
    Refunded = 5 UMETA(DisplayName = "Refunded"),
    Disputed = 6 UMETA(DisplayName = "Disputed")
};
```

## 🎒 **Inventory and Ownership Data**

### Player Inventory
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FPlayerInventory
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Inventory")
    TMap<FName, int32> OwnedItems;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Inventory")
    TMap<FName, FDateTime> AcquisitionDates;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Inventory")
    TMap<FName, FString> AcquisitionSources;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Inventory")
    TSet<FName> EquippedItems;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Inventory")
    TSet<FName> FavoriteItems;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame, Category = "Inventory")
    TMap<FName, int32> ItemUsageCount;
    
    // Inventory operations
    UFUNCTION(BlueprintCallable, Category = "Inventory")
    void AddItem(FName ItemId, int32 Quantity = 1, const FString& Source = TEXT(""));
    
    UFUNCTION(BlueprintCallable, Category = "Inventory")
    bool RemoveItem(FName ItemId, int32 Quantity = 1);
    
    UFUNCTION(BlueprintPure, Category = "Inventory")
    int32 GetItemQuantity(FName ItemId) const;
    
    UFUNCTION(BlueprintPure, Category = "Inventory")
    bool HasItem(FName ItemId, int32 MinQuantity = 1) const;
    
    UFUNCTION(BlueprintPure, Category = "Inventory")
    TArray<FName> GetItemsByCategory(EShopCategory Category) const;
    
    UFUNCTION(BlueprintCallable, Category = "Inventory")
    void EquipItem(FName ItemId);
    
    UFUNCTION(BlueprintCallable, Category = "Inventory")
    void UnequipItem(FName ItemId);
    
    UFUNCTION(BlueprintPure, Category = "Inventory")
    bool IsItemEquipped(FName ItemId) const;
    
    // Validation and maintenance
    void ValidateInventory();
    void CleanupInvalidItems();
    void UpdateItemUsage(FName ItemId);
};

USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FInventoryItem
{
    GENERATED_BODY()

    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    FName ItemId;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    int32 Quantity;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    FDateTime AcquiredTime;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    FString AcquisitionSource;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    bool bIsEquipped = false;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    bool bIsFavorite = false;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    int32 UsageCount = 0;
    
    UPROPERTY(BlueprintReadOnly, Category = "Inventory Item")
    FShopItem ItemData;
};
```

## 🛒 **Shop Configuration and Management**

### Shop Configuration
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FShopConfiguration
{
    GENERATED_BODY()

    // Shop display settings
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    int32 ItemsPerPage = 20;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    int32 FeaturedItemsCount = 6;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    bool bShowDiscountBadges = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    bool bShowNewItemBadges = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Display")
    bool bShowPopularItemBadges = true;
    
    // Refresh and update settings
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Updates")
    float ShopRefreshInterval = 300.0f; // 5 minutes
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Updates")
    float FeaturedItemsRotationInterval = 3600.0f; // 1 hour
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Updates")
    bool bAutoRefreshOnForeground = true;
    
    // Purchase settings
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Purchase")
    bool bRequirePurchaseConfirmation = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Purchase")
    bool bShowPurchaseAnimation = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Purchase")
    float PurchaseTimeoutSeconds = 30.0f;
    
    // Currency display
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Currency")
    TMap<ECurrencyType, FText> CurrencyDisplayNames;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Currency")
    TMap<ECurrencyType, TSoftObjectPtr<UTexture2D>> CurrencyIcons;
    
    // Localization
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Localization")
    bool bSupportVietnamese = true;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Localization")
    FString DefaultCurrencyCode = TEXT("VND");
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Localization")
    TMap<FString, float> CurrencyConversionRates;
};

USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FShopAnalyticsData
{
    GENERATED_BODY()

    // Shop visit analytics
    UPROPERTY(SaveGame, Category = "Analytics")
    int32 TotalShopVisits = 0;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    FDateTime LastShopVisit;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    float TotalTimeInShop = 0.0f;
    
    // Item interaction analytics
    UPROPERTY(SaveGame, Category = "Analytics")
    TMap<FName, int32> ItemViewCounts;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    TMap<FName, int32> ItemPurchaseAttempts;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    TMap<FName, int32> ItemPurchaseCompletions;
    
    // Category analytics
    UPROPERTY(SaveGame, Category = "Analytics")
    TMap<EShopCategory, int32> CategoryVisits;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    TMap<EShopCategory, float> CategoryTimeSpent;
    
    // Purchase analytics
    UPROPERTY(SaveGame, Category = "Analytics")
    int32 TotalPurchases = 0;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    float TotalMoneySpent = 0.0f;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    TMap<ECurrencyType, int32> CurrencySpent;
    
    // Conversion analytics
    UPROPERTY(SaveGame, Category = "Analytics")
    int32 PurchaseFunnelViews = 0;
    
    UPROPERTY(SaveGame, Category = "Analytics")
    int32 PurchaseFunnelCompletions = 0;
    
    // Utility functions
    UFUNCTION(BlueprintPure, Category = "Analytics")
    float GetConversionRate() const;
    
    UFUNCTION(BlueprintPure, Category = "Analytics")
    float GetAverageSessionTime() const;
    
    UFUNCTION(BlueprintPure, Category = "Analytics")
    TArray<FName> GetMostViewedItems(int32 Count = 10) const;
};
```

## Conclusion

The Data Structure Definitions provide comprehensive data models for the Shop System, covering all aspects from item definitions to transaction tracking và analytics. These structures are designed to be extensible, maintainable, và optimized for mobile performance while supporting the Vietnamese market requirements.

**Implementation Status**: ✅ **DATA STRUCTURES COMPLETE - READY FOR IMPLEMENTATION**
