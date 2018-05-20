ScriptName SCVSerpentStone Extends ObjectReference

Import Math
Actor Property PlayerRef Auto
SCVLibrary Property SCVLib Auto
ObjectReference Property SerpentStone Auto
ObjectReference Property SCV_SerpentWispHaltXMarker Auto
ObjectReference Property SCV_SerpentWispResumeXMarker Auto
ObjectReference Property SCV_SerpentWispActivator Auto

Int Angle
Auto State PlayerFar
  Event OnLoad()
    TranslateToRef(SCV_SerpentWispResumeXMarker, 100)
    ;RegisterForSingleUpdate(0.1)
  EndEvent

  Event OnBeginState()
    ;Angle = 0
    Float[] NewPosition = GetPosXYZRotateAroundRef(SerpentStone, SCV_SerpentWispResumeXMarker, 0, 0, Angle)
    TranslateTo(NewPosition[0], NewPosition[1], NewPosition[2], 0, 0, 0, 100)
    ;TranslateToRef(SCV_SerpentWispResumeXMarker, 100)
    SCV_SerpentWispActivator.Disable(False)
    ;RegisterForSingleUpdate(0.1)
  EndEvent

  Event OnTranslationAlmostComplete()
    Angle += 10
    If Angle >= 360
      Angle = 0
    EndIf
    Float[] NewPosition = GetPosXYZRotateAroundRef(SerpentStone, SCV_SerpentWispResumeXMarker, 0, 0, Angle)
    TranslateTo(NewPosition[0], NewPosition[1], NewPosition[2], 0, 0, 0, 100)
    ;SplineTranslateTo(NewPosition[0], NewPosition[1], NewPosition[2], 0, 0, 0, 1, 100)
  EndEvent

  ;/Event OnUpdate()
    Angle += 1
    Float[] NewPosition = GetPosXYZRotateAroundRef(SerpentStone, self, 0, 0, Angle)
    ;SetPosition(NewPosition[0], NewPosition[1], NewPosition[2])
    RegisterForSingleUpdate(0.1)
  EndEvent/;
EndState

State PlayerNear
  Event OnBeginState()
    TranslateToRef(SCV_SerpentWispHaltXMarker, 100)
    SCV_SerpentWispActivator.Enable(False)
  EndEvent
EndState

;-----------\
;Description \ Author: Chesko
;----------------------------------------------------------------
;Rotates a point (akObject offset from the center of
;rotation (akOrigin) by the supplied degrees fAngleX, fAngleY,
;fAngleZ, and returns the new position of the point.

;-------------\
;Return Values \
;----------------------------------------------------------------
;               fNewPos[0]      =        The new X position of the point
;               fNewPos[1]      =        The new Y position of the point
;               fNewPos[2]      =        The new Z position of the point

;                        |  1                    0                0     |
;Rx(t) =                 |  0                   cos(t)         -sin(t)  |
;                        |  0                   sin(t)          cos(t)  |
;
;                        | cos(t)                0              sin(t)  |
;Ry(t) =                 |  0                    1                0     |
;                        |-sin(t)                0              cos(t)  |
;
;                        | cos(t)              -sin(t)            0     |
;Rz(t) =                 | sin(t)               cos(t)            0     |
;                        |  0                    0                1     |

;R * v = Rv, where R = rotation matrix, v = column vector of point [ x y z ], Rv = column vector of point after rotation
;Provided angles must follow Bethesda's conventions (CW Z angle for example).
float[] function GetPosXYZRotateAroundRef(ObjectReference akOrigin, ObjectReference akObject, float fAngleX, float fAngleY, float fAngleZ)
  fAngleX = -(fAngleX)
  fAngleY = -(fAngleY)
  fAngleZ = -(fAngleZ)

  float myOriginPosX = akOrigin.GetPositionX()
  float myOriginPosY = akOrigin.GetPositionY()
  float myOriginPosZ = akOrigin.GetPositionZ()

  float fInitialX = akObject.GetPositionX() - myOriginPosX
  float fInitialY = akObject.GetPositionY() - myOriginPosY
  float fInitialZ = akObject.GetPositionZ() - myOriginPosZ

  float fNewX
  float fNewY
  float fNewZ

  ;Objects in Skyrim are rotated in order of Z, Y, X, so we will do that here as well.

  ;Z-axis rotation matrix
  float fVectorX = fInitialX
  float fVectorY = fInitialY
  float fVectorZ = fInitialZ
  fNewX = (fVectorX * cos(fAngleZ)) + (fVectorY * sin(-fAngleZ)) + (fVectorZ * 0)
  fNewY = (fVectorX * sin(fAngleZ)) + (fVectorY * cos(fAngleZ)) + (fVectorZ * 0)
  fNewZ = (fVectorX * 0) + (fVectorY * 0) + (fVectorZ * 1)

  ;Y-axis rotation matrix
  fVectorX = fNewX
  fVectorY = fNewY
  fVectorZ = fNewZ
  fNewX = (fVectorX * cos(fAngleY)) + (fVectorY * 0) + (fVectorZ * sin(fAngleY))
  fNewY = (fVectorX * 0) + (fVectorY * 1) + (fVectorZ * 0)
  fNewZ = (fVectorX * sin(-fAngleY)) + (fVectorY * 0) + (fVectorZ * cos(fAngleY))

  ;X-axis rotation matrix
  fVectorX = fNewX
  fVectorY = fNewY
  fVectorZ = fNewZ
  fNewX = (fVectorX * 1) + (fVectorY * 0) + (fVectorZ * 0)
  fNewY = (fVectorX * 0) + (fVectorY * cos(fAngleX)) + (fVectorZ * sin(-fAngleX))
  fNewZ = (fVectorX * 0) + (fVectorY * sin(fAngleX)) + (fVectorZ * cos(fAngleX))

  ;Return result
  float[] fNewPos = new float[3]
  fNewPos[0] = fNewX + myOriginPosX
  fNewPos[1] = fNewY + myOriginPosY
  fNewPos[2] = fNewZ + myOriginPosZ

  return fNewPos
endFunction
