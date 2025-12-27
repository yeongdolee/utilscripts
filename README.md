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

https://codeberg.org/yeongdolee/utilscripts 로 접속해
download 디렉터리 내부의 utilscripts.zip(최신버전)을 다운로드해
프로젝트 내부에 압축을 풀거나 utilscripts-vN.N.N.zip을 다운로드해
프로젝트 내부에 이름을 변경해 압축을 풀어주세요.

### 파일 예시

- utilscripts.zip(최신버전)
- utilscripts-v1.1.1(v1.1.1 버전)
- utilscripts-beta-v1.1.1(v1.1.1 베타 버전)

<!-- (파일은 최신 릴리즈 이전 5개까지의 파일만 보관합니다.) -->

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
a는 강도(float), b는 지속 시간(float)이다.

```gdscript
US.ShakeCamera(5.0, 0.3)
```

---

## GetNearby

좌표 a 기준으로 b만큼의 범위 내에서 그룹 c의 노드들을 Array 타입으로 반환합니다.
좌표 a는 Vector2, 범위 b는 float, 그룹 c는 String으로 그룹명을 입력한다.

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

# END
