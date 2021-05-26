with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

with RCL.TF2;

with ROSIDL.Types;

procedure Static_Transform_Publisher is

   subtype Real is ROSIDL.Types.Float64;
   subtype Radians is RCL.TF2.Radians;

begin
   if Argument_Count /= 8 then
      Put_Line ("Expected 8 parameters:"
                & " X Y Z Yaw Pitch Roll (float) From Into (string)");
      return;
   end if;

   while True loop
      Put_Line ("Publishing transform...");
      RCL.TF2.Publish_Transform
        (Static      => True,
         From        => Argument (7),
         Into        => Argument (8),
         Translation => (X => Real'Value (Argument (1)),
                         Y => Real'Value (Argument (2)),
                         Z => Real'Value (Argument (3))),
         Rotation    => (Yaw   => Radians'Value (Argument (4)),
                         Pitch => Radians'Value (Argument (5)),
                         Roll  => Radians'Value (Argument (6))));
      delay 1.0;
   end loop;
end Static_Transform_Publisher;
