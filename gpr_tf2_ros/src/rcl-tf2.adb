with C_Strings;
with GNAT.Ctrl_C;
--  with Interfaces.C.Extensions; use Interfaces;

--  with RCL.Logging;

with rclada_tf2_dark_hpp; use rclada_tf2_dark_hpp;

package body RCL.TF2 is

   function Can_Transform (From, Into : String) return Boolean
   is
   begin
      return Yes_We_Can : constant Boolean :=
        Boolean
          (Dark_Can_Transform
             (Target => C_Strings.To_C (Into).To_Ptr,
              Source => C_Strings.To_C (From).To_Ptr));
   end Can_Transform;

   --------------
   -- Shutdown --
   --------------

   procedure Shutdown is
   begin
      Dark_Shutdown;
   end Shutdown;

   -----------------------
   -- Publish_Transform --
   -----------------------

   procedure Publish_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Euler;
      Static      : Boolean := False)
   is
      use Interfaces.C;
   begin
      Dark_Publish_Transform
        (C.Extensions.Bool (Static),
         Double (Translation.X),
         Double (Translation.Y),
         Double (Translation.Z),
         Double (Rotation.Yaw),
         Double (Rotation.Pitch),
         Double (Rotation.Roll),
         C_Strings.To_C (From).To_Ptr, C_Strings.To_C (Into).To_Ptr);
   end Publish_Transform;

   ---------------
   -- Transform --
   ---------------

   function Transform (Point : Point3D;
                       From,
                       Into  : String)
                       return Point3D
   is
      use Interfaces.C;
   begin
      return Result : Point3D do
         declare
            Tf : constant Rclada_Tf2_Dark_Hpp.Point3D :=
                   Dark_Transform
                     ((Double (Point.X),
                      Double (Point.Y),
                      Double (Point.Z)),
                      Target => C_Strings.To_C (Into).To_Ptr,
                      Source => C_Strings.To_C (From).To_Ptr);
         begin
            Result := (Real (Tf.X), Real (Tf.Y), Real (Tf.Z));
         end;
      end return;
   end Transform;

begin
   Dark_Init;
   --  Must be installed after rclcpp installs theirs, or ours is ignored
   GNAT.Ctrl_C.Install_Handler (Shutdown'Access);
end RCL.TF2;
