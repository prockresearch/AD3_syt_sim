package require autopsf
package require solvate
package require autoionize
package require Orient

namespace import Orient::orient

mol load pdb dys.coor

set sel [atomselect top "all"]
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0 0 1}]
$sel move $A
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0.6 0.4 1}]
$sel move $A
set I [draw principalaxes $sel]

$sel writepdb dys_oriented.pdb

autopsf dys_oriented.pdb
solvate dys_autopsf.psf dys_autopsf.pdb -o dys_solvate -s WT -b 2.4 -x 10 -y 10 -z 10 +x 10 +y 10 +z 10

autoionize -psf dys_solvate.psf -pdb dys_solvate.pdb -o dys_ionized -sc 0.15 -cation POT

set mol1 [mol new dys_ionized.pdb type pdb waitfor all]

set rid [lindex $argv 0]
set all [atomselect top "all"]
set sel [atomselect top "resid $rid and name CA"]

$all set beta 0.0
$sel set beta 1.0

$all writepdb restraint.pdb 


exit
