private with Ada.Numerics.Generic_Elementary_Functions;

with Rclada_Tf2_Dark_Hpp;

with ROSIDL.Types;

package RCL.TF2 with Elaborate_Body is

   --  Wrap the minimal C++ stuff to comfortably access transforms directly in
   --  Ada. A bit barebones at the time (only single point transforms)

   subtype Frame is String;
   --  A reference frame, as published in /tf and /tf_static

   subtype Real is Types.Float64;

   type Radians is new ROSIDL.Types.Float64 with Convention => C;

   type Point3D is record
      X, Y, Z : aliased Real;
   end record
     with Convention => C_Pass_By_Copy;
   pragma Assert
     (Point3D'Object_Size = Rclada_Tf2_Dark_Hpp.Point3D'Object_Size);

   function Image (P : Point3D) return String;

   subtype Translation is Point3D;

   type Point_Array is array (Positive range <>) of Point3D;

   type Polar is record
      Bearing  : Radians; -- T
      Distance : Real;    -- R
   end record;

   function To_Point (P : Polar; Z : Real := 0.0) return Point3D;
   --  Convert from polar to cartesian, with optional non-zero Z value

   type Quaternion is record
      X, Y, Z, W : Real;
   end record;

   type Euler is record
      Yaw, Pitch, Roll : Radians;
   end record;

   ---------
   -- TF2 --
   ---------

   --  The actual useful things

   procedure Shutdown;
   --  The use of tf2 requires explicit shutdown of the node being used
   --  internally.

   function Can_Transform (From, Into : String) return Boolean;

   function Transform (Point : Point3D;
                       From,
                       Into  : String)
                       return Point3D;
   --  May raise if either the transformation is unknown or else the node is
   --  shutting down.

   procedure Publish_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Euler;
      Static      : Boolean := False);
   --  A static transform is published via static broadcast, and is not
   --  expected to change (fixed parts of robots).

   --  procedure Publish_Transform
   --    (From, Into  : String;
   --     Translation : TF2.Translation;
   --     Rotation    : Quaternion;
   --     Static      : Boolean := False);
   --  TODO

private

   package Elementary is new Ada.Numerics.Generic_Elementary_Functions (Real);
   use Elementary;
   use type Real;

   -----------
   -- Image --
   -----------

   function Image (P : Point3D) return String
   is ("("
       & Duration (P.X)'Image & ","
       & Duration (P.Y)'Image & ","
       & Duration (P.Z)'Image & ")");

   --------------
   -- To_Point --
   --------------

   function To_Point (P : Polar; Z : Real := 0.0) return Point3D
   is (X => P.Distance * Cos (Real (P.Bearing)),
       Y => P.Distance * Sin (Real (P.Bearing)),
       Z => Z);

end RCL.TF2;
