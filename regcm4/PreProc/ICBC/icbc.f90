!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
!
!    This file is part of ICTP RegCM.
!
!    ICTP RegCM is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    ICTP RegCM is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with ICTP RegCM.  If not, see <http://www.gnu.org/licenses/>.
!
!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

      program icbc

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                                                      !
!   ICBC is the third component of the REGional Climate Modeling       !
!   (RegCM) system version 3.0 and used to access archived global      !
!   analysed datasets at regular latitude-longititude (NNRP1, NNRP2,   !
!   ERA40, ERAIN,EIN75,EIN15, EIN25, GFS11)                            !
!   or original T159 (N80) datasets(ERAHI),                            !
!   or T42 datasets at Gaussian grids (ECWCRP, simply ECMWF), as well  !
!   as NEST run from previous FVGCM run (FVGCM), ECHAM5 run  (EH5OM)   !
!   and RegCM run (FNEST).                                             !
!                                                                      !
!   The present ICBC code could treat NNRP1, NNRP2, ECWCRP, ERA40,     !
!   ERAIN, EIN75, EIN15, EIN25, GFS11, ERAHI, FVGCM, EH5OM, and RegCM  !
!   datasets,  4 times daily.                                          !
!                                                                      !
!                        Xunqiang Bi, ESP group, Abdus Salam ICTP      !
!                                                October 07, 2009      !
!                                                                      !
!   NNRP1: NCEP/NCAR Reanalysis datasets are available at:             !
!          ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/            !
!          Current holdings: 1948 - present, 2.5x2.5L13, netCDF.       !
!   NNRP2: NCEP/DOE AMIP-II Reanalysis (Reanalysis-2) are at:          !
!          ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2/           !
!          Current holdings: 1979 - 2007, 2.5x2.5L13, netCDF.          !
!   NRP2W: Small Window (instead of global) of NNRP1/2 to save disk    !
!          space. (For example, African window: 40W,80E;60S,70N)       !
!   ECMWF: ECMWF TOGA/WCRP Uninitialized Data - (ECWCRP)               !
!          NCAR MSS:/TRENBERT/CTEC/ , ET42yymmdd, where yy=year,       !
!          mm=month, dd=day=01,04,07,10,13,16,19,22,25,28, or 31       !
!          Current holdings: January, 1993 - December, 1997            !
!          Reformatted by PWC/ICTP to direct-access binary,            !
!          T42L15, Gaussian Grid.                                      !
!   EH5OM: EH5OM run by the MPI at Hamburg, T63, Gaussian grid.        !
!          For present day  run: 1941 - 2000;                           !
!          For A1B scenario run: 2001 - 2100.                           !
!          17 pressure levels, 4 times daily, direct-access binary.    !
!   ERA40: ECMWF 40 year reanalysis datasets are available at:         !
!          http://data.ecmwf.int/data/d/era40_daily/                   !
!          Current holdings: 01/09/1957 - 31/08/2002,                  !
!          Pressure levels, 2.5x2.5L23, 4 times daily.                 !
!   ERAIN/EIN15: ECMWF INTERIM 10 year reanalysis datasets             !
!          Current holdings: 01/01/1989 - 31/05/2009,                  !
!          Pressure levels, 1.5x1.5L37, 4 times daily.                 !
!   EIN75: ECMWF INTERIM 10 year reanalysis datasets                   !
!          Current holdings: 01/01/1989 - 31/12/2007,                  !
!          Pressure levels, 0.75x0.75L37, 4 times daily.               !
!   EIN25: ECMWF INTERIM 10 year reanalysis datasets                   !
!          Current holdings: 01/01/1989 - 31/12/1998,                  !
!          Pressure levels, 2.5x2.5L37, 4 times daily.                 !
!   GFS11: NCEP Global Forecast System (GFS) product FNL are           !
!                                                available at:         !
!          http://dss.ucar.edu/datasets/ds083.2/data/fnl-yyyymm/       !
!          Current holdings: 01/01/2000 - present,                     !
!          Pressure levels, 1.0x1.0L27, 4 times daily.                 !
!   ERAHI: ECMWF 40 year reanalysis datasets, origigal model level     !
!          fields: T, U, V and log(Ps) are in spectral coefficients    !
!          Oro and Q are at the reduced Gaussian grids.                !
!          T159L60 (N80L60), 01/09/1957 - 31/08/2002.                  !
!   FVGCM: FVGCM run by the PWC group of Abdus Salam ICTP.             !
!          For present day run: 1960 - 1990;                           !
!          For A2          run: 2070 - 2100.                           !
!          1x1.25L18, 4 times daily, direct-access binary.             !
!   FNEST: do Further oneway NESTing from previous RegCM run.          !
!                                                                      !
!   The code need NetCDF library to access ERA40, ERAIN (EIN75/15/25), !
!   NNRP1 and NNRP2 data.                                              !
!   And we have already provided the NetCDF libraries for many         !
!   platforms, if your platform is unfortunately out of our support,   !
!   you need install the netcdf library by yourself.                   !
!   The code need EMOSLIB library to access ERAHI (T159L60) data, we   !
!   have just provided EMOSLIB library for LINUX PGI5 and IBM AIX.     !
!                                                                      !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      use mod_dynparam
      use mod_datenum
      use mod_grid
      use mod_ingrid
      use mod_datewk
      use mod_ecwcp
      use mod_eh5om
      use mod_ein15
      use mod_ein25
      use mod_ein75
      use mod_era40
      use mod_erahi
      use mod_fvgcm
      use mod_gfs11
      use mod_ncep
      use mod_nest
      use mod_write
      implicit none
!
! Local variables
!
      integer :: idate , idatef , iday , ifile , imon , imonnew ,       &
               & imonold , isize , iyr , nnn , inmber , numfile
      integer :: nnnend , nstart
      integer :: ierr
      character(256) :: namelistfile, prgname
      character(256) :: sstfile , finame
!
      call header(0)
!
!
!     Read input global namelist
!
      call getarg(0, prgname)
      call getarg(1, namelistfile)
      call initparam(namelistfile, ierr)
      if ( ierr/=0 ) then
        write ( 6, * ) 'Parameter initialization not completed'
        write ( 6, * ) 'Usage : '
        write ( 6, * ) '          ', trim(prgname), ' regcm.in'
        write ( 6, * ) ' '
        write ( 6, * ) 'Check argument and namelist syntax'
        stop
      end if
!
      call init_grid(iy,jx,kz)
      call init_output(jx,iy,kz)
      call initdate_icbc
      call finddate_icbc(nstart,globidate1)
      call finddate_icbc(nnnend,globidate2)

      write (*,*) 'NSTART,NNNEND: ' , nstart , nnnend
      write (*,*) 'IDATE1,IDATE2: ' , globidate1 , globidate2
 
      isize = jx*iy*4*(kz*4+3)
      numfile = 2100000000/isize
      numfile = (numfile/20)*20
 
      write (sstfile,99001) trim(dirglob), pthsep, trim(domname),       &
          & '_SST.RCM'
      open (60,file=sstfile,form='unformatted',status='old',err=100)
 
      call commhead

      if ( dattyp=='NNRP1' .or. dattyp=='NNRP2' .or. dattyp=='NRP2W' )  &
         & then
        call headernc
      else if ( dattyp=='ECMWF' ) then
        call headerec
      else if ( dattyp=='ERA40' ) then
        call headerera
      else if ( dattyp=='ERAIN' .or. dattyp=='EIN15' ) then
        call headerein15
      else if ( dattyp=='EIN75' ) then
        call headerein75
      else if ( dattyp=='EIN25' ) then
        call headerein25
      else if ( dattyp=='GFS11' ) then
        call headergfs
      else if ( dattyp=='ERAHI' ) then
        call headerehi
      else if ( dattyp=='EH5OM' ) then
        call headermpi(ehso4)
      else if ( dattyp=='FVGCM' ) then
        call headerfv
      else if ( dattyp=='FNEST' ) then
        call headnest
      else
      end if
      if ( ssttyp=='OI_WK' .or. ssttyp=='OI2WK' ) call headwk
 
      imonold = 0
      ifile = 101
      do nnn = nstart , nnnend
        idate = mdate(nnn)
        iyr = idate/1000000
        imon = idate/10000 - iyr*100
!       IF(MOD(NNN-NSTART,NUMFILE).EQ.0 .or.
!       &     (imon.ne.imonold.and.nnn.lt.nnnend.and.nnn.gt.nstart))
!       THEN
        if ( nnn==nstart .or.                                           &
           & (imon/=imonold .and. nnn<nnnend .and. nnn>nstart) ) then
          iday = idate/100 - iyr*10000 - imon*100
          write (finame,99002) trim(dirglob), pthsep, trim(domname),    &
              '_ICBC', idate
          if ( nnn>nstart ) then
            if ( dattyp=='NNRP1' .or. dattyp=='NNRP2' ) then
              call getncep(idate)
            else if ( dattyp=='NRP2W' ) then
              call getncepw(idate)
            else if ( dattyp=='ECMWF' ) then
              call getecwcp(idate)
            else if ( dattyp=='ERA40' ) then
              call getera40(idate)
            else if ( dattyp=='ERAIN' .or. dattyp=='EIN15' ) then
              call getein15(idate)
            else if ( dattyp=='EIN75' ) then
              call getein75(idate)
            else if ( dattyp=='EIN25' ) then
              call getein25(idate)
            else if ( dattyp=='GFS11' ) then
              call getgfs11(idate)
            else if ( dattyp=='ERAHI' ) then
              call geterahi(idate)
            else if ( dattyp=='EH5OM' ) then
              call geteh5om(idate)
            else if ( dattyp=='FVGCM' ) then
              call getfvgcm(idate)
            else if ( dattyp=='FNEST' ) then
              call get_nest(idate,0)
            else
            end if
          end if
          imonnew = imon + 1
          if ( imon>=12 ) then
            imonnew = 1
            iyr = iyr + 1
          end if
          idatef = iyr*1000000 + imonnew*10000 + 100
          if ( imon==1 .or. imon==3 .or. imon==5 .or. imon==7 .or.      &
             & imon==8 .or. imon==10 .or. imon==12 ) then
            inmber = (32-iday)*4 + 1
          else if ( imon==4 .or. imon==6 .or. imon==9 .or. imon==11 )   &
                  & then
            inmber = (31-iday)*4 + 1
          else
            if ( mod(iyr,4)==0 ) then
              inmber = (30-iday)*4 + 1
            else
              inmber = (29-iday)*4 + 1
            end if
            if ( mod(iyr,100)==0 ) inmber = (29-iday)*4 + 1
            if ( mod(iyr,400)==0 ) inmber = (30-iday)*4 + 1
          end if
          if ( igrads==1 ) call gradsctl(finame,idate,inmber)
          call fexist(finame)
          open (64,file=finame,form='unformatted',status='unknown',     &
              & recl=jx*iy*ibyte,access='direct')
          imonold = imon
          ifile = ifile + 1
          noutrec = 0
        end if
        if ( dattyp=='NNRP1' .or. dattyp=='NNRP2' ) then
          call getncep(idate)
        else if ( dattyp=='NRP2W' ) then
          call getncepw(idate)
        else if ( dattyp=='ECMWF' ) then
          call getecwcp(idate)
        else if ( dattyp=='ERA40' ) then
          call getera40(idate)
        else if ( dattyp=='ERAIN' .or. dattyp=='EIN15' ) then
          call getein15(idate)
        else if ( dattyp=='EIN75' ) then
          call getein75(idate)
        else if ( dattyp=='EIN25' ) then
          call getein25(idate)
        else if ( dattyp=='GFS11' ) then
          call getgfs11(idate)
        else if ( dattyp=='ERAHI' ) then
          call geterahi(idate)
        else if ( dattyp=='EH5OM' ) then
          call geteh5om(idate)
        else if ( dattyp=='FVGCM' ) then
          call getfvgcm(idate)
        else if ( dattyp=='FNEST' ) then
          call get_nest(idate,1)
        else
        end if
      end do

      call free_output
      call free_grid
 
      call finaltime(0)
      print *, 'Successfully completed ICBC'

      stop
 100  continue
      print * , 'ERROR OPENING SST.RCM FILE'
      stop '4810 IN PROGRAM ICBC'
99001 format (a,a,a,a)
99002 format (a,a,a,a,i10)
      end program icbc
