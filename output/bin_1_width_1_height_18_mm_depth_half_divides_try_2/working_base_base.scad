difference(){
import("working_base.stl");
shift = 21/2;
shift_up = 1.5;
    union(){
        translate([shift,shift,shift_up]){
            #import("working_bottom.stl");
        }
        translate([shift,shift,shift_up*2]){
            #import("working_bottom.stl");
        }
        translate([shift,shift,shift_up*3]){
            #import("working_bottom.stl");
        }
        
        
        translate([-shift,shift,shift_up]){
            #import("working_bottom.stl");
        }
        translate([-shift,shift,shift_up*2]){
            #import("working_bottom.stl");
        }
        translate([-shift,shift,shift_up*3]){
            #import("working_bottom.stl");
        }
        
        
        translate([shift,-shift,shift_up]){
            #import("working_bottom.stl");
        }
        translate([shift,-shift,shift_up*2]){
            #import("working_bottom.stl");
        }
        translate([shift,-shift,shift_up*3]){
            #import("working_bottom.stl");
        }
        
        
        translate([-shift,-shift,shift_up]){
            #import("working_bottom.stl");
        }
        translate([-shift,-shift,shift_up*2]){
            #import("working_bottom.stl");
        }
        translate([-shift,-shift,shift_up*3]){
            #import("working_bottom.stl");
        }
    }
 }