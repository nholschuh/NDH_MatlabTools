<div id="top"></div>
<!--
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
-->


<!-- PROJECT LOGO -->
<br />
<div align="center">

<!--
  <a href="https://github.com/github_username/repo_name">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
-->

<h3 align="center">NDH_MatlabTools</h3>

  <p align="center">
    <a href="https://github.com/nholschuh/NDH_MatlabTools/issues">Report Bug</a>
    ·
    <a href="https://github.com/nholschuh/NDH_MatlabTools/issues">Request Feature</a>
</p>
<br>
<p align="left">
    	This repository contains a set of functions for analyzing <a href="https://nsidc.org/data/icesat-2">ICESat-2 Data,</a> ice penetrating radar data from the <a href="https://data.cresis.ku.edu/">Center for Remote Sensing of Ice Sheets</a>, and other cryospheric geophysical data. In addition, there are a series of tutorial notebooks that break-down how to read and interpret many of these polar geophysical datasets.
	<br>
</p>
<p align="center>
	This work is primarily in support of the following awards: 
	<br> <a href="https://nspires.nasaprs.com/external/solicitations/summary.do?solId=%7bE0000836-B11D-EBF3-80E3-260784082E4B%7d&path=&method=init">NASA-80NSSC20K0958,</a> <a href="https://nspires.nasaprs.com/external/solicitations/summary.do?solId=%7BC33D2D0F-904C-4B9A-A954-C0FD8DECD7C2%7D&path=&method=init">NASA-80NSSC21K0753,</a> <a href="https://www.nsf.gov/awardsearch/showAward?AWD_ID=2019719&HistoricalAwards=false">NSF-2019719,</a> and <a href="https://www.nsf.gov/awardsearch/showAward?AWD_ID=2118285&HistoricalAwards=false">NSF-2118285.</a>
	<br>
</p>

</div>



<!-- TABLE OF CONTENTS -->
Table of Contents
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#applications">Applications in Cryospheric Science</a>
      <ul>
	    <li><a href="#icesat">ICESat</a></li>
        <li><a href="#icesat-2">ICESat-2</a></li>
        <li><a href="#ice-penetrating-radar-data">Ice Penetrating Radar Data (CReSIS/OIB)</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>




<!-- ABOUT THE PROJECT -->
## About The Project
These tools were primarily designed for use within the Holschuh lab group, but in the spirit of open science, we want to make anything that might be useful available for public use. There will likely be parts of the code that do not work when you clone this library, but it is hard for me to know all the ways this code may fail until you all test it! Feel free to reach out if something doesn't work, and I'm happy to help you debug.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- Applications -->
## Applications
The following sections provide a list of the functions that may be useful to you. Each function has a description in its header, but we provide a brief statement for each below.

In addition, there are a set of tools that allow for interactive data selection from plots within the "Graphical_Selection_Tools" directory.

### ICESat
Within the "NDH_ICESat_Tools" directory, there are several function that can help you read and manipulate ICESat-2 data.

* read_GLAH12_h5: Allows you to read in the full GLAH12 data, subsets based on variable names, or subsets based on position in the file.
* restructure_GLAH12: This converts the GLAH12 data (read by read_GLAH12_h5) to a friendlier format for use.

### ICESat 2

Within the "NDH_ICESat2_Tools" directory, there are several function that can help you read and manipulate ICESat-2 data.

* read_ATL03_h5: Allows you to read in the full ATL03 data, subsets based on variable names, or subsets based on segids.
* read_ATL06_h5: Allows you to read in the full ATL06 data, subsets based on variable names, or subsets based on segids.
* read ATL11_h5: Allows you to read in the full ATL11 data, subsets based on variable names, or subsets based on segids.
* restructure_ATL06: This converts the ATL06 data (read by read_ATL06_h5) to a friendlier format for use.
* restructure_ATL11: This converts the ATL06 data (read by read_ATL11_h5) to a friendlier format for use.

### Ice Penetrating Radar Data

Within the "NDH_CReSIS_Tools" directory, there are several function that can help you read and manipulate ICESat-2 data.

* depth_shift: This function takes in a radar dataset and converts it from two-way travel time to depth.
* elevation_shift: This function takes in a radar dataset and converts it from two-way travel time to absolute elevation (WGS84) 


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Nick Holschuh - nholschuh@amherst.edu

Project Link: [https://github.com/nholschuh/NDH_MatlabTools](https://github.com/nholschuh/NDH_MatlabTools)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* Much of the code here was built in support of my wonderful students at Amherst. Don't underestimate a passionate Amherst student!

<p align="right">(<a href="#top">back to top</a>)</p>


