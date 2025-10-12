include <../../github/kennetek/gridfinity-rebuilt-openscad/src/core/standard.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/core/bin.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/core/cutouts.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/helpers/generic-helpers.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/helpers/grid.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/helpers/grid_element.scad>
use <../../github/kennetek/gridfinity-rebuilt-openscad/src/helpers/generic-helpers.scad>

// ===== PARAMETERS ===== //

/* [Setup Parameters] */
$fa = 4;
$fs = 0.25; // .01

/* [General Settings] */
// number of bases along x-axis
gridx = 1;
// number of bases along y-axis
gridy = 1;
// bin height. See bin height information and "gridz_define" below.
gridz = 2.0646; //.1

// Half grid sized bins.  Implies "only corners".
half_grid = false;

/* [Height] */
// How "gridz" is used to calculate height.  Some exclude 7mm/1U base, others exclude ~3.5mm (4.4mm nominal) stacking lip.
gridz_define = 0; // [0:7mm increments - Excludes Stacking Lip, 1:Internal mm - Excludes Base & Stacking Lip, 2:External mm - Excludes Stacking Lip, 3:External mm]
// Overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 0;
// snap gridz height to nearest 7mm increment
enable_zsnap = false;
// If the top lip should exist.  Not included in height calculations.
include_lip = true;

/* [Compartments] */
// number of X Divisions (set to zero to have solid bin)
divx = 1;
// number of Y Divisions (set to zero to have solid bin)
divy = 1;
// Leave zero for default. Units: mm
depth = 0;  //.1

/* [Cylindrical Compartments] */
// Use this instead of bins
cut_cylinders = false;
// diameter of cylindrical cut outs
cd = 10; // .1
// chamfer around the top rim of the holes
c_chamfer = 0.5; // .1

/* [Compartment Features] */
// the type of tabs
style_tab = 5; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// which divisions have tabs
place_tab = 1; // [0:Everywhere-Normal,1:Top-Left Division]
// scoop weight percentage. 0 disables scoop, 1 is regular scoop. Any real number will scale the scoop.
scoop = 1; //[0:0.1:1]

/* [Base Hole Options] */
// only cut magnet/screw holes at the corners of the bin to save uneccesary print time
only_corners = false;
//Use gridfinity refined hole style. Not compatible with magnet_holes!
refined_holes = false;
// Base will have holes for 6mm Diameter x 2mm high magnets.
magnet_holes = false;
// Base will have holes for M3 screws.
screw_holes = false;
// Magnet holes will have crush ribs to hold the magnet.
crush_ribs = true;
// Magnet/Screw holes will have a chamfer to ease insertion.
chamfer_holes = true;
// Magnet/Screw holes will be printed so supports are not needed.
printable_hole_top = true;
// Enable "gridfinity-refined" thumbscrew hole in the center of each base: https://www.printables.com/model/413761-gridfinity-refined
enable_thumbscrew = false;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_holes, printable_hole_top);

// ===== IMPLEMENTATION ===== //

bin1 = new_bin(
    grid_size = [gridx, gridy],
    height_mm = height(gridz, gridz_define, enable_zsnap),
    fill_height = height_internal,
    include_lip = include_lip,
    hole_options = hole_options,
    only_corners = only_corners || half_grid,
    thumbscrew = enable_thumbscrew,
    grid_dimensions = GRID_DIMENSIONS_MM / (half_grid ? 2 : 1)
);

echo(str(
    "\n",
    "Infill Dimensions*: ", bin_get_infill_size_mm(bin1), "\n",
    "Bounding Box: ", bin_get_bounding_box(bin1), "\n",
    "  *Excludes Stacking Lip Support Height (if stacking lip enabled)\n",
));
echo("Height breakdown:");
pprint(bin_get_height_breakdown(bin1));

//main bin
difference() {
    union(){
        bin_render(bin1) {
            bin_subdivide(bin1, [divx, divy]) {
                depth_real = cgs(height=depth).z;
                if (cut_cylinders) {
                    cut_chamfered_cylinder(cd/2, depth_real, c_chamfer);
                } else {
                    cut_compartment_auto(
                        cgs(height=depth),
                        style_tab,
                        place_tab != 0,
                        scoop
                    );
                }
            }
        }
    }
    #union(){
        inset = 1.5;
        //bottom piece perfect but going to leave it  
            if (false){       
            translate([0,0,-0]){
                radius_cylinder_bottom = .75;
                radius_cylinder_top = 1.5;
                height_cylinder = .75;
                spread_cylinder = 17.1;
                hull(){
                    translate([spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                }
            }
            }
        //first flat lift piece
        translate([0,0,0.75]){
            radius_cylinder_bottom = 1.5 - inset/2;
            radius_cylinder_top = 1.5 - inset/2;
            height_cylinder = 2;
            spread_cylinder = 17.1 - inset/2;
            translate([0,0,0]){
                hull(){
                    translate([spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                }
            }
        }        
        //second angled piece
        translate([0,0,0.75+2]){
            radius_cylinder_bottom = 1.5 - inset/2;
            radius_cylinder_top = 3 - inset/2;
            height_cylinder = 3;
            spread_cylinder = 17.1 - inset/2;
            translate([0,0,0]){
                hull(){
                    translate([spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                }
            }
        }        
        //final straiht piece
        translate([0,0,0.75+2+3]){
            radius_cylinder_bottom = 3 - inset/2;
            radius_cylinder_top = 3 - inset/2;
            height_cylinder = 3;
            spread_cylinder = 17.1 - inset/2;
            translate([0,0,0]){
                hull(){
                    translate([spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([-spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                    translate([spread_cylinder, -spread_cylinder, 0]){
                        cylinder(h=height_cylinder, r1=radius_cylinder_bottom, r2=radius_cylinder_top);
                    }
                }
            }
        } 
    }
}
//internal cutout


