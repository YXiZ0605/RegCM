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

      program oxidant

      use mod_dynparam
      use mod_date
      use mod_grid
      use mod_wrtoxd
      use mod_header
      use mod_oxidant
!
      implicit none
!
!  Local Variables
!
      integer :: idate , iodate
      integer :: nnn , nsteps
      integer :: ierr
      character(256) :: namelistfile , prgname
!
      call header(0)
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
      call init_outoxd
!
      nsteps = idatediff(globidate2,globidate1)/ibdyfrq + 1
!
      write (*,*) 'GLOBIDATE1 : ' , globidate1
      write (*,*) 'GLOBIDATE2 : ' , globidate2
      write (*,*) 'NSTEPS     : ' , nsteps

      idate = globidate1
      iodate = idate
      call newfile(idate)

      call headermozart

      do nnn = 1 , nsteps
        if (.not. lsame_month(idate, iodate) ) then
          call getmozart(idate)
          call newfile(idate)
        end if
        call getmozart(idate)
        iodate = idate
        call addhours(idate, ibdyfrq)
      end do

      call free_grid
      call free_outoxd
      call freemozart

      end program oxidant