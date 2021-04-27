/* [Box Settings] */
// Length
Length = 100;
// Width
Width = 42;
// Height
Height = 35;
// Curve smoothness
Resolution = 50; // [1:100]
// Tolerance (Panel/rails gap)
Tolerance = 0.3;
// Decorations to ventilation holes
Vent = 0; // [0:No, 1:Yes]
// Decoration-Holes width (in mm)
Vent_width = 1.5;
// PCB feet (x4)
PCBFeet = 1; // [0:No, 1:Yes]
// PCB Length
PCBLength = 45.72; // 1.8" for Feather board
// PCB Width
PCBWidth = 17.78; // 0.9" for Feather board
// Hole diameter
FootHole = 2.5;
// Feet height
FootHeight = 8;

/* [Panel Holes] */
// DB-9 square hole height
DB9SquareHeight = 9.2;
// DB-9 square hole width
DB9SquareWidth = 18;
// DB-9 square hole corner radius
DB9SquareRadius = 3;
// DB-9 screw hole size
DB9ScrewSize = 3;
// DB-9 screw hole distance
DB9ScrewDistance = 25;
// USB hole width
USBWidth = 13;
// USB hole height
USBHeight = 8;
// USB hole corner radius
USBRadius = 3;

/* [Rendering] */
// Top shell
TopShell = 0; // [0:No, 1:Yes]
// Bottom shell
BottomShell = 1; // [0:No, 1:Yes]
// Front panel
FrontPanel = 1; // [0:No, 1:Yes]
// Back panel
BackPanel = 1; // [0:No, 1:Yes]


/* [Hidden] */
/*
These parameters are editable in the original SCAD design, but this
particular design uses some custom calculations that do not account
for these parameters being variable.
*/
// Wall thickness
Thick = 2; // [2:5]
// Curve diameter
Curve = 2; // [0.1:12]
// Foot diameter
FootDia = 8;

/*
These parameters were editable in the original SCAD design, but this design
auto calculates them.
*/
// Low left corner X position
PCBPosX = 0.5-(2*Thick);
// Low left corner Y position
PCBPosY = ((Width-(Thick*2+Curve*2+Tolerance*2)*0.5) - PCBWidth - (Thick+9) - (FootDia)) / 2;

/*
These parameters were hidden in the original design.
*/
// Shell color
ShellColor = "Orange";
// Panel color
PanelColor = "OrangeRed";
// Thick X 2 - making decorations thicker if it is a vent to make sure they go through shell
Dec_Thick = Vent ? Thick*2 : Thick;
// Depth decoration
Dec_size = Vent ? Thick*2 : 0.8;

/*
These parameters are custom to this design for calculating panel hole placement.
*/
DB9ScrewOffsetX = DB9ScrewSize / 2;
DB9ScrewOffsetY = DB9SquareHeight / 2;
DB9SquareOffsetX = ((DB9ScrewDistance + DB9ScrewSize) - DB9SquareWidth) / 2;
// DB-9 panel-mount hole
DB9PanelX = ((Width-(Thick*2+Curve*2+Tolerance*2)*0.5) - (DB9ScrewDistance+DB9ScrewSize)) / 2;
DB9PanelY = ((Height-(Thick*2+Curve*2+Tolerance*2)*0.5) - DB9SquareHeight) / 2;
// USB socket hole
USBPanelX = ((Width-(Thick*2+Curve*2+Tolerance*2)*0.5) - USBWidth) / 2;
USBPanelY = (FootHeight - (USBHeight/2));

module RoundBox($a=Length, $b=Width, $c=Height)
{
    $fn=Resolution;
    translate([0,Curve,Curve])
    {
        minkowski()
        {
            cube([$a-(Length/2),$b-(2*Curve),$c-(2*Curve)], center=false);
            rotate([0,90,0])
            {
                cylinder(r=Curve,h=Length/2, center=false);
            }
        }
    }
}

module Shell()
{
    Thick = Thick*2;
    difference()
    {
        // Side decorations
        difference()
        {
            union()
            {
                // Substraction Curveed box
                difference()
                {
                    // Median cube slicer
                    difference()
                    {
                        union()
                        {
                            // Shell
                            difference()
                            {
                                RoundBox();
                                translate([Thick/2,Thick/2,Thick/2])
                                {
                                    RoundBox($a=Length-Thick, $b=Width-Thick, $c=Height-Thick);
                                }
                            }

                            // Inside rails
                            difference()
                            {
                                translate([Thick+Tolerance,Thick/2,Thick/2])
                                {
                                    RoundBox($a=Length-((2*Thick)+(2*Tolerance)), $b=Width-Thick, $c=Height-(Thick*2));
                                }
                                translate([((Thick+Tolerance/2)*1.55),Thick/2,Thick/2+0.1]) // +0.1 added to avoid the artefact
                                {
                                    RoundBox($a=Length-((Thick*3)+2*Tolerance), $b=Width-Thick, $c=Height-Thick);
                                }
                            }
                        }

                        // Internal cube to subtract
                        translate([-Thick,-Thick,Height/2])
                        {
                            cube([Length+100, Width+100, Height], center=false);
                        }
                    }

                    // Core subtraction for ends
                    translate([-Thick/2,Thick,Thick])
                    {
                        RoundBox($a=Length+Thick, $b=Width-Thick*2, $c=Height-Thick);
                    }
                }


                // Screw tab legs
                difference()
                {
                    union()
                    {
                        translate([3*Thick +5,Thick,Height/2])
                        {
                            rotate([90,0,0])
                            {
                                $fn=6;
                                cylinder(d=16,Thick/2);
                            }
                        }

                       translate([Length-((3*Thick)+5),Thick,Height/2])
                       {
                            rotate([90,0,0])
                            {
                                $fn=6;
                                cylinder(d=16,Thick/2);
                            }
                        }

                    }

                    translate([4,Thick+Curve,Height/2-57])
                    {
                        rotate([45,0,0])
                        {
                            cube([Length,40,40]);
                        }
                    }
                    translate([0,-(Thick*1.46),Height/2])
                    {
                        cube([Length,Thick*2,10]);
                    }
                }
            }

            // Outside decorations
            union()
            {

                for(i=[0:Thick:Length/4])
                {

                        // Ventilation holes
                        translate([10+i,-Dec_Thick+Dec_size,1])
                        {
                            cube([Vent_width,Dec_Thick,Height/4]);
                        }
                        translate([(Length-10) - i,-Dec_Thick+Dec_size,1])
                        {
                            cube([Vent_width,Dec_Thick,Height/4]);
                        }
                        translate([(Length-10) - i,Width-Dec_size,1])
                        {
                            cube([Vent_width,Dec_Thick,Height/4]);
                        }
                        translate([10+i,Width-Dec_size,1])
                        {
                            cube([Vent_width,Dec_Thick,Height/4]);
                        }


                }

            }
        }

        // Screw holes
        union()
        {
            $fn=50;
            translate([3*Thick+5,20,Height/2+4]){
                rotate([90,0,0]){
                cylinder(d=2,20);
                }
            }
            translate([Length-((3*Thick)+5),20,Height/2+4]){
                rotate([90,0,0]){
                cylinder(d=2,20);
                }
            }
            translate([3*Thick+5,Width+5,Height/2-4]){
                rotate([90,0,0]){
                cylinder(d=2,20);
                }
            }
            translate([Length-((3*Thick)+5),Width+5,Height/2-4]){
                rotate([90,0,0]){
                cylinder(d=2,20);
                }
            }
        }

    }
}

// Single PCB mounting foot with curved base
module foot(FootDia,FootHole,FootHeight)
{
    Curve=2;
    color(ShellColor)
    translate([0,0,Curve-1.5])
    difference()
    {
        difference()
        {
            cylinder(d=FootDia+Curve,FootHeight-Thick, $fn=100);
            rotate_extrude($fn=100)
            {
                translate([(FootDia+Curve*2)/2,Curve,0])
                {
                    minkowski()
                    {
                        square(10);
                        circle(Curve, $fn=100);
                    }
                }
            }
        }
        cylinder(d=FootHole,FootHeight+1, $fn=100);
    }
}

// All PCB mounting feet and visual PCB reference
module Feet(){

    // Render a PCB that is not exported
    translate([3*Thick+4.5,Thick+7.5,FootHeight+(Thick/2)-1.5])
    {
        %import("lib/3403 Feather M0 Express.stl");
    }

    // Place all four feet
    translate([3*Thick+7,Thick+10,Thick/2])
    {
        foot(FootDia,FootHole,FootHeight);
    }
    translate([(3*Thick)+PCBLength+7,Thick+10,Thick/2])
    {
        foot(FootDia,FootHole,FootHeight);
    }
    translate([(3*Thick)+PCBLength+7,(Thick)+PCBWidth+10,Thick/2])
    {
        foot(FootDia,FootHole,FootHeight);
    }
    translate([3*Thick+7,(Thick)+PCBWidth+10,Thick/2])
    {
        foot(FootDia,FootHole,FootHeight);
    }

}

// Panel
module Panel(Length,Width,Thick,Curve)
{
    scale([0.5,1,1])
    minkowski()
    {
        cube([Thick,Width-(Thick*2+Curve*2+Tolerance),Height-(Thick*2+Curve*2+Tolerance)]);
        translate([0,Curve,Curve])
        rotate([0,90,0])
        cylinder(r=Curve,h=Thick, $fn=100);
    }
}

// Circle panel hole
// Cx=Cylinder X position | Cy=Cylinder Y position | Cdia= Cylinder dia | Cheight=Cyl height
module CylinderHole(OnOff,Cx,Cy,Cdia){
    if(OnOff==1)
    {
        translate([Cx,Cy,-1])
        cylinder(d=Cdia,10, $fn=50);
    }
}

// Square panel hole
// Sx=Square X position | Sy=Square Y position | Sl= Square Length | Sw=Square Width | Curve = Round corner
module SquareHole(OnOff,Sx,Sy,Sl,Sw,Curve){
    if(OnOff==1)
    {
        minkowski(){
            translate([Sx+Curve/2,Sy+Curve/2,-1])
            cube([Sl-Curve,Sw-Curve,10]);
            cylinder(d=Curve,h=10, $fn=100);
        }
    }

}

// Linear text panel label
module LText(OnOff,Tx,Ty,Font,Size,Content)
{
    if(OnOff==1)
    {
        translate([Tx,Ty,Thick+.5])
        linear_extrude(height = 0.5)
        {
            text(Content, size=Size, font=Font);
        }
    }
}

// Circular text panel panel
module CText(OnOff,Tx,Ty,Font,Size,TxtRadius,Angl,Turn,Content){
    if(OnOff==1)
    {
        Angle = -Angl / len(Content);
        translate([Tx,Ty,Thick+.5])
        for (i= [0:len(Content)-1] )
        {
            rotate([0,0,i*Angle+90+Turn])
            translate([0,TxtRadius,0])
            {
                linear_extrude(height=0.5)
                {
                    ext(Content[i], font=Font, size=Size, valign="baseline", halign="center");
                }
            }
        }
    }
}

// Main rendering
// Top shell
if(TopShell==1)
{
    color(ShellColor,1)
    {
        translate([0,Width,Height+0.2])
        {
            rotate([0,180,180])
            {
                Shell();
            }
        }
    }
}

// Bottom shell
if(BottomShell==1)
{
    color(ShellColor)
    {
        Shell();
    }

    // PCB feet
    if (PCBFeet==1)
    {
        translate([PCBPosX,PCBPosY,0])
        {
            Feet();
        }
    }
}

// Front panel
if(FrontPanel==1)
{
    color(PanelColor)
    {
        translate([Length-(Thick*2+Tolerance/2),Thick+Tolerance/2,Thick+Tolerance/2])
        {
            difference()
            {
                Panel(Length,Width,Thick,Curve);

                rotate([90,0,90])
                {
                    // DB-9 Connector
                    CylinderHole(1,DB9PanelX+DB9ScrewOffsetX,DB9PanelY+DB9ScrewOffsetY,DB9ScrewSize);
                    SquareHole(1,DB9PanelX+DB9SquareOffsetX,DB9PanelY,DB9SquareWidth,DB9SquareHeight,DB9SquareRadius);
                    CylinderHole(1,DB9PanelX+DB9ScrewOffsetX+DB9ScrewDistance,DB9PanelY+DB9ScrewOffsetY,DB9ScrewSize);
                }
            }
        }
    }
}

// Back panel
if(BackPanel==1)
{
    color(PanelColor)
    {
        translate([Thick+Tolerance/2,Thick+Tolerance/2,Thick+Tolerance/2])
        {
            difference()
            {
                Panel(Length,Width,Thick,Curve);

                rotate([90,0,90]){
                    // USB
                    SquareHole(1,USBPanelX,USBPanelY,USBWidth,USBHeight,USBRadius);
                }
            }

        }
    }
}
