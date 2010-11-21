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

      module mod_maps

      use m_realkinds

      real(SP) , allocatable , dimension(:,:) :: coriol , dlat , dlon ,  &
                     & dmap , htgrid , lndout , mask , dpth , snowam ,  &
                     & texout , xlat , xlon , xmap
      real(SP) , allocatable , dimension(:,:,:) :: frac_tex

      real(SP) , allocatable , dimension(:,:) :: coriol_s , dlat_s ,     &
                        & dlon_s , dmap_s , htgrid_s , lndout_s ,       &
                        & mask_s , dpth_s , snowam_s , texout_s ,       &
                        & xlat_s , xlon_s , xmap_s
      real(SP) , allocatable , dimension(:,:,:) :: frac_tex_s

      real(SP) , allocatable , dimension(:) :: sigma
      real(SP) :: xn

      contains

      subroutine allocate_grid(iy,jx,kz,ntex)
        implicit none
        integer , intent(in) :: iy,jx,kz,ntex
        allocate(sigma(kz+1))
        allocate(coriol(iy,jx))
        allocate(xlat(iy,jx))
        allocate(xlon(iy,jx))
        allocate(dlat(iy,jx))
        allocate(dlon(iy,jx))
        allocate(xmap(iy,jx))
        allocate(dmap(iy,jx))
        allocate(htgrid(iy,jx))
        allocate(dpth(iy,jx))
        allocate(lndout(iy,jx))
        allocate(mask(iy,jx))
        allocate(snowam(iy,jx))
        allocate(texout(iy,jx))
        allocate(frac_tex(iy,jx,ntex))
      end subroutine allocate_grid

      subroutine allocate_subgrid(iysg,jxsg,ntex)
        implicit none
        integer , intent(in) :: iysg,jxsg,ntex
        allocate(coriol_s(iysg,jxsg))
        allocate(xlat_s(iysg,jxsg))
        allocate(xlon_s(iysg,jxsg))
        allocate(dlat_s(iysg,jxsg))
        allocate(dlon_s(iysg,jxsg))
        allocate(xmap_s(iysg,jxsg))
        allocate(dmap_s(iysg,jxsg))
        allocate(htgrid_s(iysg,jxsg))
        allocate(dpth_s(iysg,jxsg))
        allocate(lndout_s(iysg,jxsg))
        allocate(mask_s(iysg,jxsg))
        allocate(snowam_s(iysg,jxsg))
        allocate(texout_s(iysg,jxsg))
        allocate(frac_tex_s(iysg,jxsg,ntex))
      end subroutine allocate_subgrid

      subroutine free_grid
        implicit none
        deallocate(sigma)
        deallocate(coriol)
        deallocate(xlat)
        deallocate(xlon)
        deallocate(dlat)
        deallocate(dlon)
        deallocate(xmap)
        deallocate(dmap)
        deallocate(htgrid)
        deallocate(dpth)
        deallocate(lndout)
        deallocate(mask)
        deallocate(snowam)
        deallocate(texout)
        deallocate(frac_tex)
      end subroutine free_grid

      subroutine free_subgrid
        implicit none
        deallocate(coriol_s)
        deallocate(xlat_s)
        deallocate(xlon_s)
        deallocate(dlat_s)
        deallocate(dlon_s)
        deallocate(xmap_s)
        deallocate(dmap_s)
        deallocate(htgrid_s)
        deallocate(dpth_s)
        deallocate(lndout_s)
        deallocate(mask_s)
        deallocate(snowam_s)
        deallocate(texout_s)
        deallocate(frac_tex_s)
      end subroutine free_subgrid

      end module mod_maps
