MODEL DESCRIPTION

CATS2008a is a high-resolution regional model of the entire 
circum-Antarctic ocean, built on a polar stereographic grid at 4 km
resolution, with standard latitude and longitude of 71<sup>o</sup>S and
70<sup>o</sup>W (see above figure). The model domain includes ocean 
cavities under the floating ice shelves. The model coastline is based on
the MODIS MOA <a href="#Scambos_etal_2007">[<i>Scambos et al</i>., 2007]</a> 
feature  identification files, adjusted to match ICESat-derived grounding 
lines for the Ross and Filchner-Ronne ice shelves and Interferometeric 
Synthetic Aperture Radar (InSAR) grounding lines for the Larsen-C Ice 
Shelf (data courtesy of Eric Rignot, JPL). The water depth map for open 
water is based on the <a href="http://topex.ucsd.edu/marine_topo/mar_topo.html">
2007 release update</a> to 
<a href="#Smith_Sandwell_1997"><i>Smith and Sandwell</i> [1997]</a>,
which uses marine gravity from TOPEX/Poseidon and ERS
satellites to interpolate between available ship-track depth data. 
Adjustments to this map have been made in various regions, including
the open shelf in front of the Larsen-C Ice Shelf which has been blended 
with GEBCO bathymetry.
	
Water column thickness ("wct") under ice shelves follows the data sets 
described by <a href="#Padman_etal_2002"><i>Padman et al</i>. [2002]</a>. 
We are aware of problems with wct for Larsen-C Ice Shelf: these will be 
amended in CATS2008b, due later in 2008.
	
The model development follows two primary steps. We first develop an 
optimized forward model used direct factorization of the linearized 
shallow water equations, forced at the open boundary by tide heights from 
the global inverse model <a href="Model_TPXO71.html">TPXO7.1</a> and 
by astronomical forcing. The model is tuned to data by the use of a linear 
benthic drag coefficient rather than the more usual quadratic drag 
formulation. Each of ten primary tidal harmonics is tuned separately.
While the optimized forward model is not as accurate as could be obtained 
with more sophisticated tidal physics, it creates a relatively accurate
"prior" model for use in the next step of data assimilation.
	
The second step is to assimilate available data sets. We assimilate 
(<i>i</i>) TOPEX/Poseidon radar altimetry from the ocean ocean when no
sea ice is present, (<i>ii</i>) a set of ~50 "high quality" tide records 
(including bottom pressure recorders, coastal tide gauges, and a few 
long-duration GPS records on ice shelves), and (<i>iii</i>) ICESat laser
altimetry data at crossovers on the Ross and Filchner-Ronne ice shelves
(see <a href="#Padman_Fricker_2005"><i>Padman and Fricker</i> [2005]</a>).
The set of assimilated tide records is drawn from the larger set described at
our <a href="http://www.esr.org/antarctic_tg_index.html"> Antarctic Tide Gauge Datebase</a>
web page.

CATS2008a is distributed with a Matlab Graphical User Interface ("GUI") and 
access scripts, collectively referred to as the  
"TMD" (the Tide Model Driver) toolbox. TMD can be used to quickly access and browse 
the model, and to make tide height and current (velocity component) predictions. 
For an overview of the GUI and scripts, view or download the 
<a href="README_TMD.pdf">README PDF file</a>. For FORTRAN access routines, 
please go to the 
<a href="http://www.coas.oregonstate.edu/research/po/research/tide/otis.html" target="_top"> 
Oregon State "OTIS"</a> web page.

Please reference "pers. comm., L. Padman, 2008" for use of CATS2008a. 
A paper describing the model in more detail will be submitted to 
<i>J. Geophys. Res.</i> later in 2008. 

REFERENCES

Padman, L., H. A. Fricker, R. Coleman, S. Howard, and S. Erofeeva, 2002: 
A new tidal model for the Antarctic ice shelves and seas, 
<i>Ann. Glaciol.</i>, <b>34</b>, 247-254.

Scambos, T.A., T.M. Haran, M.A. Fahnestock, T.H. Painter and J. Bohlander, 
2007), MODIS-based Mosaic of Antarctica (MOA) data sets: Continent-wide 
surface morphology and snow grain size, <i>Remote Sensing of 
Environment</i>, <b>111</b>(2-3), 242-257.

Smith, W. H. F., and D. T. Sandwell, 1997: Global seafloor topography 
from satellite altimetry and ship depth soundings, <i>Science</i>, 
<b>277</b>, 1957-1962.

ADDITIONAL MATLAB SCRIPTS

Users are advised to download the latest version of TMD. However, at a minimum,
the TMD toolbox needs to contain the following three additional scripts:

mapll.m & mapxy.m ... for converting between (lat,lon) and polar stereo (x,y)

xy_ll_CATS2008a_4km.m ... used by TMD to access mapll and mapxy

These scripts are included in the zip file, and ened to be copied into your
TMD toolbox directory.

SOURCES OF CONSTITUENTS

From: Lana Erofeeva [serofeev@coas.oregonstate.edu]
Sent: Thursday, May 08, 2008 5:02 PM
To: padman@esr.org
Subject: Re: CATS2008

Hi, Laurie,

I put the "best" inverse in

ftp://ftp.coas.oregonstate.edu/pub/lana/LP/CATs

(hf.CATs2008.out and uv.CATs2008.out).

The list of solutions included is:

Constituent m2   taken from ../out/TPT2_ICE_HQTG/hf.m2_1.out
Constituent s2   taken from ../out/TPT2_HQTG/hf.s2_0.3.out
Constituent n2   taken from ../out/h0.CATs2008.out
Constituent k2   taken from ../out/TPT2_HQTG/hf.k2_10.out
Constituent k1   taken from ../out/TPT2_ICE_HQTG/hf.k1_1.out
Constituent o1   taken from ../out/TPT2_ICE_HQTG/hf.o1_1.out
Constituent p1   taken from ../out/h0.CATs2008.out
Constituent q1   taken from ../out/h0.CATs2008.out
Constituent mf   taken from ../out/h0.CATs2008.out
Constituent mm   taken from ../out/h0.CATs2008.out

(Similar list for transports)

h0.CATs2008.out is the prior, obtained by direct factorization of 
frequency domain SWE equations at fr.vel.=1.5m/s with elevation 
OBC from tpxo7.1

Lana