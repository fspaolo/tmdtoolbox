
Modification of the Matlab Tide Model Driver (TMD)[1], to run
'tmd_tide_pred.m' in parallel on several HDF5 files.

[1] https://www.esr.org/research/polar-tide-models/tmd-software/

Some of the original Matlab scripts have been modified to improve performance.

Modifications include replacing loops by vectorization, and improving
the I/O for multiple data files and parallelization.

The modifications were made by Alex Gardner and Fernando Paolo, and they are
marked in the code.

The main script is (see header for how to use it):

    tmd_toolbox/tidecor.m

Download the lasted Tide Model and TMD Matlab toolbox:

    http://www.esr.org/ptm_index.html
    https://www.esr.org/polar_tide_models/Model_TPXO71.html


Fernando Paolo <fspaolo@gmail.com>
Oct 12, 2017
