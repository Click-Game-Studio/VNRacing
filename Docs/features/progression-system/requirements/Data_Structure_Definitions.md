# Data Structure Definitions - Enhanced Progression System

**Project**: PrototypeRacing
**Document**: Data Structure Definitions
**Version**: 1.1
**Date**: 2025-09-07
**Status**: Implementation Ready

> ⚠️ **Implementation Status**: This document describes data structures for the COMPLETE design vision.
> See implementation status markers (✅/⏳) on each struct below.

## 🏗️ **Core Data Structures**

### Player Progression Core ⏳ Planned (XP system not implemented)
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FPlayerProgressionData
{
    GENERATED_BODY()

    // Basic progression
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 PlayerLevel = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 TotalXP = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 CurrentLevelXP = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 XPToNextLevel = 1000;
    
    // Skill progression
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TMap<ESkillType, int32> SkillLevels;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TMap<ESkillType, int32> SkillXP;
    
    // Statistics
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FPlayerStatistics Statistics;
    
    // Timestamps
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime CreationTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime LastActiveTime;
    
    // Validation
    bool IsValid() const;
    void RepairData();
};

UENUM(BlueprintType)
enum class ESkillType : uint8
{
    Racing = 0,
    Drifting = 1,
    Precision = 2,
    Speed = 3,
    Endurance = 4,
    Customization = 5,
    Social = 6
};
```

### Player Statistics
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FPlayerStatistics
{
    GENERATED_BODY()

    // Racing stats
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 TotalRaces = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 RacesWon = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 RacesLost = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    float TotalDistanceKM = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    float TotalRaceTime = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    float BestLapTime = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    float TopSpeed = 0.0f;
    
    // Drift stats
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 TotalDriftPoints = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 BestDriftScore = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    float TotalDriftTime = 0.0f;
    
    // Precision stats
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 PerfectLaps = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 CleanRaces = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    float AverageRacingLine = 0.0f;
    
    // Social stats
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 FriendsAdded = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 ClubContributions = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 MultiplayerWins = 0;
    
    // Customization stats
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 CarsOwned = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 PartsCollected = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 LiveriesCreated = 0;
    
    // Calculated properties
    UFUNCTION(BlueprintPure)
    float GetWinRate() const;
    
    UFUNCTION(BlueprintPure)
    float GetAverageSpeed() const;
    
    UFUNCTION(BlueprintPure)
    int32 GetTotalScore() const;
};
```

## 🏆 **Achievement System Data** ✅ Implemented (Basic - 4 categories)

### Achievement Definition ✅ Implemented
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FAchievementDefinition
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FName AchievementID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText DisplayName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText Description;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText FlavorText;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EAchievementCategory Category;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EAchievementRarity Rarity;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<FAchievementCondition> Conditions;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<FRewardItem> Rewards;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TSoftObjectPtr<UTexture2D> Icon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    bool bIsHidden = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    bool bIsRepeatable = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 Points = 10;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<FName> Prerequisites;
    
    // Validation
    bool IsValidForPlayer(const FPlayerProgressionData& PlayerData) const;
    bool CheckCompletion(const FPlayerStatistics& Stats) const;
};

UENUM(BlueprintType)
enum class EAchievementCategory : uint8
{
    Racing = 0,
    Exploration = 1,
    Customization = 2,
    Social = 3,
    Seasonal = 4,
    Special = 5,
    Hidden = 6
};

UENUM(BlueprintType)
enum class EAchievementRarity : uint8
{
    Common = 0,
    Uncommon = 1,
    Rare = 2,
    Epic = 3,
    Legendary = 4
};
```

### Achievement Condition
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FAchievementCondition
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EAchievementConditionType Type;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FString Parameter;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 TargetValue;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EComparisonOperator Operator = EComparisonOperator::GreaterOrEqual;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    bool bMustBeInSingleSession = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FName RequiredTrack = NAME_None;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FName RequiredCar = NAME_None;
    
    // Evaluation
    bool EvaluateCondition(const FPlayerStatistics& Stats, int32 CurrentValue) const;
};

UENUM(BlueprintType)
enum class EAchievementConditionType : uint8
{
    RaceWins = 0,
    TotalDistance = 1,
    PerfectLaps = 2,
    CarCollection = 3,
    CustomizationItems = 4,
    SocialInteractions = 5,
    TimeTrialRecords = 6,
    DriftPoints = 7,
    TopSpeed = 8,
    ConsecutiveWins = 9,
    CleanRaces = 10,
    MultiplayerWins = 11,
    SeasonalTiers = 12
};

UENUM(BlueprintType)
enum class EComparisonOperator : uint8
{
    Equal = 0,
    GreaterThan = 1,
    GreaterOrEqual = 2,
    LessThan = 3,
    LessOrEqual = 4
};
```

### Achievement Progress
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FAchievementProgress
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FName AchievementID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TMap<int32, int32> ConditionProgress;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    bool bIsCompleted = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    bool bRewardsClaimed = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime CompletionTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 CompletionCount = 0;
    
    // Progress calculation
    UFUNCTION(BlueprintPure)
    float GetCompletionPercentage(const FAchievementDefinition& Definition) const;
    
    UFUNCTION(BlueprintPure)
    bool IsReadyToComplete(const FAchievementDefinition& Definition) const;
};
```

## 🎮 **Seasonal Progression Data** ⏳ Planned

### Seasonal Data ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FSeasonalProgressionData
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 SeasonID = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 CurrentTier = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 SeasonalXP = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    bool bHasPremiumPass = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TArray<int32> ClaimedFreeTiers;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TArray<int32> ClaimedPremiumTiers;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime SeasonStartTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime SeasonEndTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TMap<FName, int32> SeasonalChallengeProgress;
    
    // Calculated properties
    UFUNCTION(BlueprintPure)
    float GetSeasonProgress() const;
    
    UFUNCTION(BlueprintPure)
    int32 GetDaysRemaining() const;
    
    UFUNCTION(BlueprintPure)
    bool IsSeasonActive() const;
};
```

### Battle Pass Tier ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FBattlePassTier
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 TierNumber;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 RequiredXP;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<FRewardItem> Rewards;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    bool bIsMajorTier = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TSoftObjectPtr<UTexture2D> TierIcon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText TierName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FLinearColor TierColor = FLinearColor::White;
};
```

## 👥 **Social System Data** ⏳ Planned

### Club Data ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FClubData
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FString ClubID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FString ClubName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FString Description;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FString OwnerPlayerID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TArray<FClubMember> Members;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 Level = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 XP = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime CreationTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TArray<FClubChallenge> ActiveChallenges;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FClubSettings Settings;
    
    // Calculated properties
    UFUNCTION(BlueprintPure)
    int32 GetMemberCount() const { return Members.Num(); }
    
    UFUNCTION(BlueprintPure)
    bool IsFull() const { return Members.Num() >= Settings.MaxMembers; }
};

USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FClubMember
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FString PlayerID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FString PlayerName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    EClubMemberRole Role;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 ContributionPoints = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime JoinTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    FDateTime LastActiveTime;
};

UENUM(BlueprintType)
enum class EClubMemberRole : uint8
{
    Member = 0,
    Officer = 1,
    Leader = 2,
    Owner = 3
};
```

### Club Challenge ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FClubChallenge
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FName ChallengeID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText ChallengeName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText Description;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EClubChallengeType Type;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 TargetValue;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    int32 CurrentProgress = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FDateTime StartTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FDateTime EndTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<FRewardItem> Rewards;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite, SaveGame)
    TMap<FString, int32> MemberContributions;
    
    // Progress tracking
    UFUNCTION(BlueprintPure)
    float GetCompletionPercentage() const;
    
    UFUNCTION(BlueprintPure)
    bool IsActive() const;
    
    UFUNCTION(BlueprintPure)
    bool IsCompleted() const;
};

UENUM(BlueprintType)
enum class EClubChallengeType : uint8
{
    TotalDistance = 0,
    RaceWins = 1,
    DriftPoints = 2,
    PerfectLaps = 3,
    MultiplayerWins = 4,
    CustomizationItems = 5
};
```

## 🏅 **Leaderboard Data** ⏳ Planned

### Leaderboard Entry ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FLeaderboardEntry
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FString PlayerID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FString PlayerName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 Rank;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 Score;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FString AdditionalData;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FDateTime LastUpdateTime;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    bool bIsFriend = false;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FString ClubName;
};

UENUM(BlueprintType)
enum class ELeaderboardType : uint8
{
    GlobalLevel = 0,
    WeeklyXP = 1,
    TotalDistance = 2,
    BestLapTime = 3,
    DriftScore = 4,
    SeasonalTier = 5,
    ClubContribution = 6
};
```

## 💰 **Reward System Data** ✅ Implemented (Basic)

### Reward Item ✅ Implemented
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FRewardItem
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    ERewardType Type;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FName ItemID;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 Quantity = 1;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    ERewardRarity Rarity = ERewardRarity::Common;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TSoftObjectPtr<UTexture2D> Icon;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText DisplayName;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FText Description;
    
    // Validation
    bool IsValid() const;
    FString GetDisplayString() const;
};

UENUM(BlueprintType)
enum class ERewardType : uint8
{
    Currency = 0,
    XP = 1,
    Car = 2,
    CarPart = 3,
    Customization = 4,
    Achievement = 5,
    Title = 6,
    Avatar = 7,
    Emote = 8
};

UENUM(BlueprintType)
enum class ERewardRarity : uint8
{
    Common = 0,
    Uncommon = 1,
    Rare = 2,
    Epic = 3,
    Legendary = 4
};
```

## 📱 **Mobile-Specific Data** ⏳ Planned

### Offline Rewards ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FOfflineRewards
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 CoinsEarned = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 XPEarned = 0;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    TArray<FRewardItem> BonusRewards;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float OfflineHours = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 IdleRacesCompleted = 0;
    
    // Calculation
    UFUNCTION(BlueprintPure)
    int32 GetTotalValue() const;
    
    UFUNCTION(BlueprintPure)
    bool HasRewards() const;
};
```

### Performance Data ⏳ Planned
```cpp
USTRUCT(BlueprintType)
struct PROTOTYPERACING_API FMobilePerformanceData
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float AverageFPS = 60.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float MemoryUsageMB = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float BatteryUsagePercent = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    float DeviceTemperature = 0.0f;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    EDevicePerformanceTier PerformanceTier;
    
    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FDateTime LastUpdateTime;
};

UENUM(BlueprintType)
enum class EDevicePerformanceTier : uint8
{
    Low = 0,
    Medium = 1,
    High = 2,
    Ultra = 3
};
```

## Conclusion

Data Structure Definitions cung cấp comprehensive blueprint cho tất cả data structures cần thiết trong enhanced progression system. Với detailed struct definitions, enums, và validation methods, development team có clear guidance để implement robust data management system.

**Implementation Status**: ✅ **DATA STRUCTURES COMPLETE - READY FOR IMPLEMENTATION**
