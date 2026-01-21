# Integration Patterns - VNRacing

**Breadcrumbs:** Docs > Architecture > Integration Patterns

**Version:** 1.0.0 | **Date:** 2026-01-20

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

> [!WARNING]
> This file appears to contain corrupted or incomplete code snippets. Use with caution.

---

## Table of Contents

1. [Overview](#overview)
2. [UGameInstanceSubsystem Pattern](#1-ugameinstancesubsystem-pattern)
   - [Base Pattern](#base-pattern)
   - [Sub Access](#sub-access)
   - [Subsystem Dependencies](#subsystem-dependencies)
3. [Interface-Based Design Pattern](#2-interface-based-design-pattern)
4. [Facade Pattern](#3-facade-pattern)
5. [Factory Pattern](#4-factory-pattern)
6. [Event-Driven Communication Pattern](#5-event-driven-communication-pattern)
7. [Plugin Integration Patterns](#6-plugin-integration-patterns)
   - [SimpleCarPhysics Integration](#simplecarphysics-integration)
8. [Data Table Pattern](#7-data-table-pattern)
9. [Save System Integration](#8-save-system-integration)
10. [Integration Best Practices](#integration-best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

This document describes the plugin and subsystem integration patterns used in VNRacing.

---

## 1. UGameInstanceSubsystem Pattern

### Base Pattern

Tat ca core syal access.

```cpp
UCLASS()
class
{
BODY()

public:
    virtual void Initialize
    virtual void Deinitialize() override;
    
prive:
    TMap<FString, FCarConfigura
    FCarCo
};
```

### Sub Access

```cpp
// d context
;

print
UCarCu>(
    U
);
``

### Subsystem Dependencies

``cpp
voion)

   tion);
  
    Pr);
    FanServiceSubsystem = GetGameInstance()->GetSubsystem<UFanServiceSubsys();
 m>();
   
    m>();
   r>();
    
m);
    check(tem);
}
```

---

## 2. Interface-Based Design Pat

#


claider
{
    GENERATED_BODY()

p
 0;
 
    v 0;

    
 ;
    virtual void App
  ) = 0;

    virtual FPerformanceStats Cal0;
 
    
 0;
    vir
    vir;
};
```

### IProgre

```cpp
class PROTOTYPERACING_API IProgressionDataProvider
{
    GENERATED_BODY()

public:
    ;
    virtual void T;
    
    
    ) = 0;
    virtual TArray<FArea;
    virtual TArray<FTrackProgress> GetAllTrack;
    
    v 0;
  
    
= 0;
};
`

##

`p
c

    GEN

lic:
    virtual TArray<FVolumeConfig> GetVolume
  rol() = 0;
    virtual FDisplaySe= 0;
    virtua= 0;
    virtual FLanguageSettings GetLanguageSetting() = 
    
    virtual v;
    0;
   
    
    virtual void SaveSet= 0;
   () = 0;
};
```

###ce

```cpp

{
    GENERATED_BODY()

p
    UFUNCTION(Blueprble)
();

    UFUNCTION(
    FVe

    UFUNCTION(BlueprintNativeEvent, Bluee)
    float GetIconSize();
};
```

---

## 3. Facade Pattern

### UProgree

```cpp
UCLAS
clder
{
pub
m
    virtual TArray<FCityProoverride

      s();
    }
    
 tem
    virtual FFanServride
 {
       
    }
    
ems
    virtual void HandleRaceCompleted(const FEndRacePlrride
    {
d();
        Pr
        HandleCalculateRnking);
  
    }
  
private:
stem;
    Utem;
    UAchi
    UCarRatingSubsystem* Ca
 tem;
};
```

---

## rn

### UVehiclery

```cpp
S()
class 
{
public:
    ASimulatePhysicsCarWithCustom* SpawnRacingCar(
 orld,
       rDef,
    
        
    );
    
    A(
    
        const FBaseCarDefinition& CarDef,
        const FCarConfiguration& Config,
     m

};
```

---

## 5. Event-Driven Communication Pattern

### on

```cpp
DECLAnged);
DECLARE_DYNAMIC_MULTICAST_DE
DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FOnCarConfigurationFaileon);

UPROPERTY(BlueprintAssigon")
FOnCarConf

UPROPERTY(BlueprintAssignabn")
FOnPerformded;
```

###s

```cp

{
   id())
    {
  
      n;
  }
    
tID);
   
}
```

### Subscribing to 

```cpp
void UGarageWidget::NativeC
{
    Super::NativeConstruct();
    
    ())
    {
        CCM->OnCarConfiguraged);
       );
    }
}

void U
{
    if (UCarCustomizationManager* ))
    {
        );
        CCM->OnPerformanceSt
    }
    
    Suct();
}
```

---

## 6. Plugin Integration Patterns

### SimpleCarPhysics Int

```cpp
UCLASS()
class ASimulatePhysicsCar : public APawn
{
protected:

    USimpleCarPhysicsComponent* Pnent;
    
:
    ASimulatePhysicsCar()
    {
   
    }
    

    {
        Super::BeginPlay();
 
        if (UCa>())
        {
     ());
        Stats);
        }
    }
    
tats)
    {
    );
        Physic;
        PhysicsComponent->SetTurnAngle(Stae);
 }
};
```



```cpp
UCLASS()
c
{
protected:
    UPROPERTY(EditDef
    UpIcon;
    
public:
    vde
 
y();
        
 
        {
     
        }
    }
    
    ide
    {
 )
{
            MMS->UnregisterMinimapEnthis);
    }
   
 ;
   
    
   
); }
    virtu }
};
```

---

## rn

#

```cpp
void UCarCustomizationManager::InitializeDataTable(
    r,
 Parts,
le,
    U
    UDatal,
    Uvel,
    l)
{
 ;
    Cs;
   le;
   arColor;
   Decal;
    PerfoatLevel;
    Cerial;
}

bool st
{
    return BaseCarsDataTable != nullptr 
     
   &&
           CarColorsDr;
}
```

#ccess

```cpp
FBaseCar

    ifable)
    {
    );
    }
 
    FBaseC
    if (Row)
    {
    
    }
    
  
}
```

---

## 8. Save System Integern

### C

```cpp
void ion()
{
    if (UCarSaveGameManager* SaveManager = GetGameInstance()->GetSubsystem<UCar())
    {

        ),
        ,
    
     ex
      );
        
        if (bSuccess)
        {
     st();
     }
      else

     ;
   }
    }
}

v
{
    i>())
    {
        SaveMandex);
    }
}
```

---

## Integration Best Prac

### 1. Loose Coupling
- Use
- Evenication
- Avoid directures

### 2. Clear Ownersp
- Subr data
- Single 
- Clear lifecycle management

### 3.ing
- Validatputs
- Gracefu
- elegates

### 4.
-
- Cpriate


bility
- In

- Clear separation ofns

---



- [System Overview](./systed)
- [Data Flow](./data-flow.md)
- [Technology Stack](./techtack.md)
