!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
!
!    This file is part of RegCM model.
!
!    RegCM model is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    RegCM model is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with RegCM model.  If not, see <http://www.gnu.org/licenses/>.
!
!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

      subroutine avgdata2d(favg,f,n1,n2,n3,n4,ihr,vmisdat)
 
      implicit none
!
! Dummy arguments
!
      integer :: ihr , n1 , n2 , n3 , n4
      real(4) :: vmisdat
      real(4) , dimension(n1,n2,n3) :: f
      real(4) , dimension(n1,n2,n3,n4) :: favg
      intent (in) f , ihr , n1 , n2 , n3 , n4 , vmisdat
      intent (inout) favg
!
! Local variables
!
      integer :: i , j , l
!
      do l = 1 , n3
        do j = 1 , n2
          do i = 1 , n1
            if ( f(i,j,l)>vmisdat ) then
              favg(i,j,l,ihr) = favg(i,j,l,ihr) + f(i,j,l)
            else
              favg(i,j,l,ihr) = vmisdat
            end if
          end do
        end do
      end do
 
      end subroutine avgdata2d
