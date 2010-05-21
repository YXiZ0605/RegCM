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

      subroutine htsig(t,h,pstar,ht,sig,im,jm,km)
      use mod_constants , only : rovg
      use mod_preproc_param , only : ptop
      implicit none
!
! Dummy arguments
!
      integer :: im , jm , km
      real(4) , dimension(im,jm,km) :: h , t
      real(4) , dimension(im,jm) :: ht , pstar
      real(4) , dimension(km) :: sig
      intent (in) ht , im , jm , km , pstar , sig , t
      intent (inout) h
!
! Local variables
!
      integer :: i , j , k
      real(4) :: tbar
!
      do j = 1 , jm
        do i = 1 , im
          h(i,j,km) = ht(i,j) + rovg*t(i,j,km)                     &
                    & *log(pstar(i,j)/((pstar(i,j)-ptop)*sig(km)+ptop))
        end do
      end do
      do k = km - 1 , 1 , -1
        do j = 1 , jm
          do i = 1 , im
            tbar = 0.5*(t(i,j,k)+t(i,j,k+1))
            h(i,j,k) = h(i,j,k+1)                                       &
                     & + rovg*tbar*log(((pstar(i,j)-ptop)*sig(k+1)      &
                     & +ptop)/((pstar(i,j)-ptop)*sig(k)+ptop))
          end do
        end do
      end do
      end subroutine htsig