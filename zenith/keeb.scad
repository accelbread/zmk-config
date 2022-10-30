$fa = 1;
$fs = .4;

rows = 3;
cols = 5;

plate_angle = 50;
tab_width = 5;
bottom_height = 2;
min_feature = 1;
nicenano_clearance = 2;
tape_width = 2;

plate_thickness = 3;
wall_thickness = 3;

key_spacing = 5;
stagger = [0,15,20,12.5,12.5];

key_cutout_width = 14;
key_offset = key_cutout_width + key_spacing;

key_cutout_2_width = 16.4;
key_cutout_2_offset = (key_cutout_2_width - key_cutout_width) / 2;

exclusion_z = 5 + 3.3 - plate_thickness;

plate_border_x = tan(plate_angle)*exclusion_z +
                 wall_thickness/cos(plate_angle);
plate_border_y = wall_thickness * 2 + key_cutout_2_offset;

key_grid_x = cols*key_cutout_width + (cols - 1)*key_spacing;
key_grid_y = rows*key_cutout_width + (rows - 1)*key_spacing + max(stagger);
plate_x = key_grid_x + 2*plate_border_x;
plate_y = key_grid_y + 2*plate_border_y;

side_base = cos(plate_angle)*plate_x;
side_height = sin(plate_angle)*plate_x;
back_height = side_height - wall_thickness*tan(plate_angle);

back_width = plate_y-2*wall_thickness;
bottom_offset = (bottom_height+wall_thickness)/tan(plate_angle);
bottom_x = side_base-bottom_offset-wall_thickness;

plate_tab_1 = 2.5 * tab_width;
plate_tab_4 = plate_x - 2.5 * tab_width;
plate_tab_2 = plate_tab_1 + 1/3 *(plate_tab_4-plate_tab_1);
plate_tab_3 = plate_tab_1 + 2/3 *(plate_tab_4-plate_tab_1);

back_tab_1 = back_height / 4;
back_tab_2 = back_height / 4 * 3;

bottom_tab_1 = bottom_x / 4;
bottom_tab_2 = bottom_x / 4 * 3;

bottom_tab_3 = back_width / 4;
bottom_tab_4 = back_width / 4 * 3;

nut_z = 1.7;
nut_x = 4;
screw_size = 2;

inch = 25.5;

nicenano_width = 18.25;
nicenano_length = 33.33;
usbc_height = 3.2;
usbc_width = 9;
switch_width = 6.28;
switch_height = 6.49;
delta = 0.01;

hole_tolerance=.1;

module key_grid() {
    translate([plate_border_x,plate_border_y,0])
    for(c = [0:1:4])
        translate([key_offset*c,stagger[c],0])
        for(r = [0:1:2])
            translate([0,key_offset*r,0])
                square(key_cutout_width);
}

module key_grid_2() {
    translate([plate_border_x,plate_border_y,0])
    for(c = [0:1:4])
        translate([key_offset*c,stagger[c],0])
        for(r = [0:1:2])
            translate([0,key_offset*r,0])
            translate([-key_cutout_2_offset,-key_cutout_2_offset,0])
                square(key_cutout_2_width);
}

module tab_cutout(use_delta=delta, tolerance = 0) {
    translate([-tab_width * 1.5 - tolerance,-use_delta-tolerance,0])
        square([tab_width+2*tolerance, wall_thickness+use_delta+2*tolerance]);
    translate([.5 * tab_width - tolerance,-use_delta-tolerance,0])
        square([tab_width+2*tolerance, wall_thickness+use_delta+2*tolerance]);
}

module tab(height = wall_thickness) {
    translate([-tab_width * 1.5,-delta,0])
        square([tab_width,height+delta]);
    translate([.5 * tab_width,-delta,0])
        square([tab_width,height+delta]);
}

module 2D_plate() {
    difference() {
        square([plate_x, plate_y]);
        key_grid();
        translate([plate_tab_1, 0, 0])
            tab_cutout();
        translate([plate_tab_2, 0, 0])
            tab_cutout();
        translate([plate_tab_3, 0, 0])
            tab_cutout();
        translate([plate_tab_4, 0, 0])
            tab_cutout();
        translate([plate_tab_1, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
        translate([plate_tab_2, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
        translate([plate_tab_3, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
        translate([plate_tab_4, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
    }
}

module 2D_plate_2() {
    difference() {
        square([plate_x, plate_y]);
        key_grid_2();
        translate([plate_tab_1, 0, 0])
            tab_cutout();
        translate([plate_tab_2, 0, 0])
            tab_cutout();
        translate([plate_tab_3, 0, 0])
            tab_cutout();
        translate([plate_tab_4, 0, 0])
            tab_cutout();
        translate([plate_tab_1, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
        translate([plate_tab_2, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
        translate([plate_tab_3, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
        translate([plate_tab_4, plate_y, 0])
        mirror([0,1,0])
            tab_cutout();
    }
}

module key_exclusion_zone() {
    translate([0,0,-exclusion_z])
    linear_extrude(height=exclusion_z)
        key_grid();
}

module plate() {
    rotate(plate_angle,[0,-1,0])
    {
        linear_extrude(height=plate_thickness/2)
            2D_plate();
        translate([0, 0, plate_thickness/2])
        linear_extrude(height=plate_thickness/2)
            2D_plate_2();
        %key_exclusion_zone();
    }
}

module 2D_side() {
    difference() {
        union() {
            polygon([[0,0],
                     [side_base,0],
                     [side_base,side_height]]);
            rotate(plate_angle,[0,0,1]) {
                translate([plate_tab_1,0,0])
                    tab(plate_thickness);
                translate([plate_tab_2,0,0])
                    tab(plate_thickness);
                translate([plate_tab_3,0,0])
                    tab(plate_thickness);
                translate([plate_tab_4,0,0])
                    tab(plate_thickness);
            }
        }

        translate([side_base,0,0])
        rotate(90,[0,0,1]) {
            translate([back_tab_1,0,0])
            tab_cutout();
            translate([back_tab_2,0,0])
            tab_cutout();
        }
        mirror([0,1,0]) {
            translate([bottom_offset+bottom_tab_1,-wall_thickness-bottom_height,0])
                tab_cutout(use_delta=0,tolerance=hole_tolerance);
            translate([bottom_offset+bottom_tab_2,-wall_thickness-bottom_height,0])
                tab_cutout(use_delta=0,tolerance=hole_tolerance);
        }
    }
}

module 2D_back_side() {
    difference() {
        2D_side();
        translate([side_base-wall_thickness-tape_width-usbc_height,
                   bottom_height+wall_thickness+nicenano_clearance+
                   .5*nicenano_width-.5*usbc_width,
                   0])
            square([usbc_height,usbc_width]);
        translate([side_base-wall_thickness-tape_width-switch_width,
                   (back_tab_1 + back_tab_2 )/2 - .5 * switch_height,
                   0])
            square([switch_width,switch_height]);
    }
}

module side() {
    rotate(90,[1,0,0])
    translate([0,0,-wall_thickness])
    linear_extrude(height=wall_thickness,convexity=10)
        2D_side();
}

module back_side() {
    translate([0,plate_y-wall_thickness,0])
    rotate(90,[1,0,0])
    translate([0,0,-wall_thickness])
    linear_extrude(height=wall_thickness,convexity=10)
        2D_back_side();
}

module 2D_back() {
    difference() {
        union() {
            square([back_height, back_width]);
            translate([back_tab_1,0,0])
            mirror([0,1,0])
                tab();
            translate([back_tab_2,0,0])
            mirror([0,1,0])
                tab();
            translate([back_tab_1,back_width,0])
                tab();
            translate([back_tab_2,back_width,0])
                tab();
        }
        rotate(90,[0,0,1]) {
            translate([bottom_tab_3,-wall_thickness-bottom_height,0])
                tab_cutout(use_delta=0,tolerance=hole_tolerance);
            translate([bottom_tab_4,-wall_thickness-bottom_height,0])
                tab_cutout(use_delta=0,tolerance=hole_tolerance);
        }
    }

}

module back() {
    translate([side_base,wall_thickness,0])
    rotate(90,[0,-1,0])
    linear_extrude(height=wall_thickness,convexity=10)
        2D_back();
}

module 2D_bottom() {
    union() {
        square([bottom_x,back_width]);
        mirror([0,1,0]) {
            translate([bottom_tab_1,0,0])
                tab();
            translate([bottom_tab_2,0,0])
                tab();
        }
        translate([bottom_tab_1,back_width,0])
            tab();
        translate([bottom_tab_2,back_width,0])
            tab();
        translate([bottom_x,0,0])
        rotate(90,[0,0,1])
        mirror([0,1,0]) {
            translate([bottom_tab_3,0,0])
                tab();
            translate([bottom_tab_4,0,0])
                tab();
        }
    }
}

module bottom() {
    translate([bottom_offset,wall_thickness,bottom_height])
    linear_extrude(height=wall_thickness,convexity=10)
        2D_bottom();
}

module tungsten() {
    color("gray")
    cube(inch);
}

module nicenano() {
    color("blue")
    cube([nicenano_width,nicenano_length,usbc_height]);
}

separation = 10;

*union() {
    translate([separation*cos(plate_angle+90),0,separation*sin(plate_angle+90)])
    plate();
    translate([0,-separation,0])
    side();
    translate([0,separation,0])
    back_side();
    translate([separation,0,0])
    back();
    translate([0,0,-separation])
    bottom();
    translate([side_base-wall_thickness-tape_width,
               back_width+wall_thickness-nicenano_length,
               bottom_height+wall_thickness+nicenano_clearance])
    rotate(90,[0,-1,0])
    *nicenano();
    translate([side_base-wall_thickness-inch-tape_width-usbc_height-
               nicenano_clearance,
               .5*plate_y-.5*inch,
               bottom_height+wall_thickness])
    *tungsten();
}

translate([.1,.1,0])
offset(delta=.1)
*2D_plate();

translate([.1,.1,0])
offset(delta=.1)
2D_plate_2();

translate([.1,.1+wall_thickness,0])
offset(delta=.1)
*2D_bottom();

translate([.1,.1+wall_thickness,0])
offset(delta=.1)
*2D_back();

translate([.1,.1,0])
offset(delta=.1)
*2D_side();

translate([.1,.1,0])
offset(delta=.1)
*2D_back_side();
