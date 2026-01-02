<!-- ---
marp: true
theme: default
paginate: true
title: UtilScript (US) Documentation
--- -->

# UtilScripts (US)

### Godot Engine Global Utility Library

유틸 함수, 글로벌 이벤트, 랜덤, 씬 관리 등을  
**Autoload(Singleton)** 로 제공하는 공용 스크립트

(이 문서에서 모든 매개변수는 a, b 형식으로 사용됩니다.)

---

## 지원 기능

- 글로벌 참조 (Player, MainCamera)
- 글로벌 이벤트 버스
- 랜덤 유틸리티
- Invoke / Instantiate / Destroy
- 씬 관리
- 카메라 흔들림
- 그룹 호출
- 범위 탐색
- 마우스 월드 좌표

---

## UtilScripts 다운로드

https://codeberg.org/yeongdolee/utilscripts/archive/master.zip
위 링크로 접속해 전체 저장소 코드를 ZIP 형식으로
다운로드해 프로젝트 내부에 압축을 풀어주세요.

---

## Autoload 설정

`Project Settings > Globals > Autoload`

이름: **US**

등록 경로 : `utilscripts/utilscripts/utilscripts.gd`

등록 후에는 스크립트에서 US.함수, US.클래스.메서드 형식으로 사용할 수 있습니다.

---

## 글로벌 변수

글로벌 변수들은 기본 설정이 필요합니다.

### Player

플레이어 노드 참조

```gdscript
func _ready():
    US.Player = self
```

<!-- --- -->

### MainCamera

메인 카메라 참조

```gdscript
func _ready():
    US.MainCamera = self
```

---

## GlobalEvent

전역 이벤트를 송수신하는 클래스입니다.

**EmitSignal 메서드**
a라는 이벤트명으로 매개변수 b를 송신합니다. a는 String, b는 Array(매개변수를 리스트로 전달)입니다.

**ConnectSignal 메서드**
a라는 이벤트명으로 전역 이벤트를 수신합니다. 수신을 받을 시 함수 b가 호출됩니다. 이때 함수 b는 Callable이고, EmitSignal 메서드의 매개변수 리스트 b가 함수 b의 매개변수로 전달됩니다.

```gdscript
US.GlobalEvent.ConnectSignal("GameOver", Callable(self, "_on_game_over"))
US.GlobalEvent.EmitSignal("GameOver", [])
```

---

## Random 유틸

랜덤한 값을 일정한 범위 내에서 반환합니다.

**RangeI 메서드**
a 이상 b 미만의 수 중에서 랜덤한 정수(int)를 반환해줍니다.

**RangeF 메서드**
a 이상 b 미만의 수 중에서 랜덤한 실수(float)를 반환해줍니다.

**Value 메서드**
0부터 1까지의 수 중 랜덤한 수를 반환해줍니다(확률용).

```gdscript
US.Random.RangeI(0, 10)
US.Random.RangeF(0.0, 1.0)
US.Random.Value()
```

---

## Invoke 함수

b초 후에 a 함수를 실행해줍니다.
이때, 함수명인 a는 호출 가능한 함수(Callable)이고, 대기 시간(초)인 b는 숫자(int or float)입니다.

```gdscript
US.Invoke(Callable(self, "_do_something"), 1.5)
```

---

## Instantiate 함수

씬 a를 d 노드 아래에 인스턴스화해 추가합니다.
위치를 설정하고 싶으면 b에 Vector를 넣으면 되고, 회전을 설정하려면
c에 회전값을 설정해야 합니다.

회전값 c의 타입은 2D일 땐 라디안(float)을, 3D일 땐 각도인 Vector3를 권장합니다.

```gdscript
US.Instantiate(scene, position, rotation, parent)
```

---

## Destroy 함수

b초만큼 대기한 후 노드 a를 현재 씬에서 제거(queue_free)합니다.
b를 생략하면 즉시 노드가 제거됩니다.

```gdscript
US.Destroy(node)
US.Destroy(node, 2.0)
```

---

## 씬 관리 함수들

**RestartScene 함수**
현재 실행중인 씬을 재시작합니다.

**LoadScene 함수**
현재 실행중인 씬을 씬 a로 교체합니다.

```gdscript
US.RestartScene()
US.LoadScene("res://scenes/Main.tscn")
```

---

## LookAtSmooth 함수

Node2D 전용 함수로, 부드러운 회전을 보간하는 기능을 합니다.
a는 노드(Node), b는 타겟 포지션(Vector2), c는 weight(float)으로 0.0에서 1.0 사이의 값만 입력할 수 있습니다.

```gdscript
US.LookAtSmooth(node, target_pos, weight)
```

---

## CallGroup 함수

a 그룹에 속한 모든 노드에 함수 b를 호출합니다.
리스트 c를 설정하면 함수 b의 매개변수로 입력됩니다.

이때 함수 b는 a 그룹에 속한 노드에 존재해야 합니다. 존재하지 않을 경우, 함수가 실행되지 않습니다.

그룹명 a는 문자열(String), 함수명 b는 문자열(String), 매개변수 c는 리스트(Array) 타입입니다.

```gdscript
US.CallGroup("Enemy", "TakeDamage", [10])
```

---

## ShakeCamera

전역 값인 MainCamera 기준으로 Tween 기반의 흔들림을 생성합니다.
a는 강도(float), b는 지속 시간(float)입니다.

```gdscript
US.ShakeCamera(5.0, 0.3)
```

---

## GetNearby

좌표 a 기준으로 b만큼의 범위 내에서 그룹 c의 노드들을 Array 타입으로 반환합니다.
좌표 a는 Vector2, 범위 b는 float, 그룹 c는 String으로 그룹명을 입력해야 합니다.

```gdscript
US.GetNearby(center, radius, "Enemy")
```

---

## GetMouseWorldPos

게임 월드 기준 현재 마우스 커서의 위치(Vector2)를 반환해줍니다.

```gdscript
US.GetMouseWorldPos()
```

---

## Wait

a초만큼 대기합니다. a는 float 타입입니다.
이 함수는 await과 함께 사용해야 합니다.

```gdscript
await US.Wait(3.0)
```

---

# Player Scripts

플레이어의 움직임 등에 관한 스크립트입니다.

---

## PlayerMovement3D / PlayerMovement2D

CharacterBody2D/3D에 사용할 수 있는 스크립트로, 기본적인 WASD 이동을 지원합니다.

---

## NoGravity PlayerMovement3D / PlayerMovement2D

PlayerMovement 스크립트와 같은 기능을 하지만 중력이 반영되지 않습니다.

---

## PlayerMoveHere3D

CharacterBody3D에 사용할 수 있는 스크립트로, 플레이어를 마우스를 우클릭하는 지점으로 부드럽게 이동시킵니다.
이때 우클릭으로 이동할 수 있는 지점은 `CollisionObject3D > Collision > Layer`가 2여야 합니다.
우클릭 시 이펙트를 표시시킬 수도 있습니다. 이펙트 씬을 비워두면 이펙트가 재생되지 않는다.

---

## PlayerMoveHere3D Gravity

PlayerMoveHere3D와 같은 역할을 하지만 중력이 적용됩니다.
다만, 사전 설정이 필요합니다. 플레이어(CharaterBody3D)의 `CollisionObject3D > Collision > Mask`가 1, 2 모두 설정되어있어야 하고, `CollisionObject3D > Collision > Layer`가 1로 설정되어있어야 합니다.

---

## FollowCamera3D

Camera3D에 부착할 수 있는 스크립트로, 일정한 구도에서 플레이어를 Offset만큼 멀리서 따라가게 만듭니다.

---

# License

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

이 프로젝트는 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ko) 라이선스를 따릅니다.
