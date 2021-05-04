with ROSIDL.Types;

package RCL.TF2 with Elaborate_Body is

   --  Wrap the minimal C++ stuff to comfortably access transforms directly in
   --  Ada

   type Translation is record
      X, Y, Z : ROSIDL.Types.Float64;
   end record;

   subtype Radians is ROSIDL.Types.Float64;

   type Rotation is record
      Yaw, Pitch, Roll : Radians;
   end record;

   procedure Shutdown;
   --  The use of tf2 requires explicit shutdown of the node being used
   --  internally.

   procedure Publish_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Rotation;
      Static      : Boolean := False);
   --  A static transform is published via static broadcast, and is not
   --  expected to change (fixed parts of robots).

end RCL.TF2;
