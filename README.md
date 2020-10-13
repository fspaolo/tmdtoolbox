# Modified TMD Matlab Toolbox

This is a modification of the Matlab Tide Model Driver (TMD):

https://www.esr.org/research/polar-tide-models/tmd-software/

Originaly developed by [Laurie Padman](https://www.esr.org/staff/laurence-padman/)

This wraper runs `tmd_tide_pred.m` in parallel on several HDF5 files.

## Notes

Some original Matlab scripts have been modified to improve performance.

Modifications include replacing loops by vectorization, and improving
the I/O to allow multiple input data files and parallelization.

Modifications were made by Alex Gardner and Fernando Paolo, and they
have been marked in the code.

## Usage

The main script to run is (see header for documentation):

    tmd_toolbox/tidecor.m 

For optimal performance, merge/split the input files into N blocks, whith
N equal number of cores (even if the files end up fairly large).
To merge/split use (from [`captoolkit`](https://github.com/fspaolo/captoolkit)):

    merge.py 
    split.py

For downloading the lasted Tide Model and TMD Matlab toolbox:

    (TMD)   http://www.esr.org/ptm_index.html  
    (Model) https://www.esr.org/polar_tide_models/Model_TPXO71.html

## Recipe

Clone the package:

    git https://github.com/fspaolo/tmdtoolbox.git

Add models:

    cd tmdtoolbox
    mkdir DATA
    # put Model_* and grid_* files into DATA

Edit the header of `tidecor.m`, and run:

    /Applications/Matlab2016b/bin/matlab -nodesktop < tidecor.m

## Notes

The tide and load-tide corrections are applied as:

    h_cor = h - tide - load

or equivalentely, the full tide correction is:

    h_tide = tide + load


Fernando Paolo (fspaolo@gmail.com)  
Oct 12, 2017
