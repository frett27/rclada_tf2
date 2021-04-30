package body RCL.TF2 is

   ------------------------------
   -- Publish_Static_Transform --
   ------------------------------

   procedure Publish_Static_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Rotation)
   is
   begin
      raise Program_Error with "unimplemented";
   end Publish_Static_Transform;

end RCL.TF2;
