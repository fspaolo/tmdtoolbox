# Modified TMD Matlab Toolbox

Modification of the Matlab Tide Model Driver (TMD)[1] for running
`tmd_tide_pred.m` in parallel on several HDF5 files.

[1] https://www.esr.org/research/polar-tide-models/tmd-software/

Some original Matlab scripts have been modified to improve performance.

Modifications include replacing loops by vectorization, and improving
the I/O for multiple data files and parallelization.

The modifications were made by Alex Gardner and Fernando Paolo, and they
have been marked in the code.

The main script is (see header for documentation):

    tmd_toolbox/tidecor.m

Download the lasted Tide Model and TMD Matlab toolbox:

    (TMD) http://www.esr.org/ptm_index.html
    (Model) https://www.esr.org/polar_tide_models/Model_TPXO71.html


Fernando Paolo (fspaolo@gmail.com)  
Oct 12, 2017
