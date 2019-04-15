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

module mod_hgt

  implicit none

  private

  ! Standard Gravity (m/sec**2) 3rd CGPM
  real(4) , parameter :: egrav = 9.80665
  ! Gas constant for dry air in Joules/kg/K
  real(4) , parameter :: rgas = 287.05823
  ! Standard atmosphere ICAO 1993
  real(4) , parameter :: lrate = 0.00649

  real(4) , parameter :: bltop = 0.960
  ! real(4) , parameter :: rovg = rgas/egrav
  real(4) , parameter :: rovg = 29.2716599

  public :: height_hydro
  public :: height_nonhydro

  contains

  subroutine height_hydro(im,jm,km,t,ipstar,topo,sig,ptop,p,hp)
    implicit none
    integer , intent(in) :: im , jm , km
    real(4) , intent(in) , dimension(km,jm,im) :: t
    real(4) , intent(in) , dimension(jm,im) :: topo , ipstar
    real(8) , intent(in) :: ptop
    real(4) , intent(in) :: p
    real(4) , intent(in) , dimension(km) :: sig
    real(4) , intent(out) , dimension(jm,im) :: hp

    real(4) :: psfc , temp , wb , wt , ptp , tbar
    integer :: i , j , k , kb , kbc , kt
    real(4) , dimension(jm,im) :: pstar
    real(4) , dimension(km) :: psig
    real(4) , dimension(km) :: htsig
    !
    !  HEIGHT DETERMINES THE HEIGHT OF PRESSURE LEVELS.
    !     ON INPUT:
    !        H AND T ARE HEIGHT AND TEMPERATURE ON SIGMA, RESPECTIVELY.
    !        PSTAR = SURFACE PRESSURE - MODEL TOP PRESSURE.
    !        SIG = SIGMA LEVELS.
    !        P = PRESSURE LEVELS DESIRED.
    !     ON OUTPUT:
    !        ALL FIELDS EXCEPT H ARE UNCHANGED.
    !        H HAS HEIGHT FIELDS AT KP PRESSURE LEVELS.
    !
    !  FOR UPWARD EXTRAPOLATION, T IS CONSIDERED TO HAVE 0 VERITCAL DERIV.
    !  FOR DOWNWARD EXTRAPOLATION, T HAS LAPSE RATE OF TLAPSE (K/KM)
    !     AND EXTRAPOLATION IS DONE FROM THE LOWEST SIGMA LEVEL ABOVE
    !     THE BOUNDARY LAYER (TOP ARBITRARILY TAKEN AT SIGMA = BLTOP).
    !     EQUATION USED IS EXACT SOLUTION TO HYDROSTATIC RELATION,
    !     GOTTEN FROM R. ERRICO (ALSO USED IN SLPRES ROUTINE):
    !      Z = Z0 - (T0/TLAPSE) * (1.-EXP(-R*TLAPSE*LN(P/P0)/G))
    !
    ptp = real(ptop)
    pstar = ipstar * 0.01
    kbc = 1
    do k = 1 , km
      if ( sig(k) < bltop ) kbc = k
    end do
    do j = 1 , jm
      do i = 1 , im
        do k = 1 , km
          psig(k) = sig(k)*(pstar(j,i)-ptp) + ptp
        end do
        psfc = pstar(j,i)
        htsig(km) = topo(j,i) + rovg*t(km,j,i) * &
                      log(psfc/((psfc-ptp)*sig(km)+ptp))
        do k = km - 1 , 1 , -1
          tbar = 0.5*(t(k,j,i)+t(k+1,j,i))
          htsig(k) = htsig(k+1) + rovg*tbar * &
             log(((psfc-ptp)*sig(k+1)+ptp)/((psfc-ptp)*sig(k)+ptp))
        end do
        kt = 1
        do k = 1 , km
          if ( psig(k) < p ) kt = k
        end do
        kb = kt + 1
        if ( p <= psig(1) ) then
          temp = t(1,j,i)
          hp(j,i) = htsig(1) + rovg*temp*log(psig(1)/p)
        else if ( (p > psig(1)) .and. (p < psig(km)) ) then
          wt = log(psig(kb)/p)/log(psig(kb)/psig(kt))
          wb = log(p/psig(kt))/log(psig(kb)/psig(kt))
          temp = wt*t(kt,j,i) + wb*t(kb,j,i)
          temp = (temp+t(kb,j,i))/2.0
          hp(j,i) = htsig(kb) + rovg*temp*log(psig(kb)/p)
        else if ( (p >= psig(km)) .and. (p <= psfc) ) then
          temp = t(km,j,i)
          hp(j,i) = topo(j,i) + rovg*temp*log(psfc/p)
        else if ( p > psfc ) then
          temp = t(kbc,j,i) + lrate*(htsig(kbc)-topo(j,i))
          hp(j,i) = topo(j,i) + &
                  (temp/lrate)*(1.0-exp(+rovg*lrate*log(p/psfc)))
        end if
      end do
    end do
  end subroutine height_hydro

  subroutine height_nonhydro(im,jm,km,t,ipstar,topo,sig,ptop,pp,p,hp)
    implicit none
    integer , intent(in) :: im , jm , km
    real(4) , intent(in) , dimension(km,jm,im) :: t , pp
    real(4) , intent(in) , dimension(jm,im) :: topo , ipstar
    real(8) , intent(in) :: ptop
    real(4) , intent(in) :: p
    real(4) , intent(in) , dimension(km) :: sig
    real(4) , intent(out) , dimension(jm,im) :: hp

    real(4) :: psfc , temp , wb , wt , ptp , tbar
    integer :: i , j , k , kb , kbc , kt
    real(4) , dimension(jm,im) :: pstar
    real(4) , dimension(km) :: psig
    real(4) , dimension(km) :: htsig
    !
    !  HEIGHT DETERMINES THE HEIGHT OF PRESSURE LEVELS.
    !     ON INPUT:
    !        H AND T ARE HEIGHT AND TEMPERATURE ON SIGMA, RESPECTIVELY.
    !        PSTAR = SURFACE PRESSURE - MODEL TOP PRESSURE.
    !        SIG = SIGMA LEVELS.
    !        P = PRESSURE LEVELS DESIRED.
    !     ON OUTPUT:
    !        ALL FIELDS EXCEPT H ARE UNCHANGED.
    !        H HAS HEIGHT FIELDS AT KP PRESSURE LEVELS.
    !
    !  FOR UPWARD EXTRAPOLATION, T IS CONSIDERED TO HAVE 0 VERITCAL DERIV.
    !  FOR DOWNWARD EXTRAPOLATION, T HAS LAPSE RATE OF TLAPSE (K/KM)
    !     AND EXTRAPOLATION IS DONE FROM THE LOWEST SIGMA LEVEL ABOVE
    !     THE BOUNDARY LAYER (TOP ARBITRARILY TAKEN AT SIGMA = BLTOP).
    !     EQUATION USED IS EXACT SOLUTION TO HYDROSTATIC RELATION,
    !     GOTTEN FROM R. ERRICO (ALSO USED IN SLPRES ROUTINE):
    !      Z = Z0 - (T0/TLAPSE) * (1.-EXP(-R*TLAPSE*LN(P/P0)/G))
    !
    ptp = real(ptop)
    pstar = ipstar * 0.01
    kbc = 1
    do k = 1 , km
      if ( sig(k) < bltop ) kbc = k
    end do
    do j = 1 , jm
      do i = 1 , im
        do k = 1 , km
          psig(k) = sig(k)*(pstar(j,i)-ptp) + ptp + (pp(k,j,i) * 0.01)
        end do
        psfc = pstar(j,i)
        htsig(km) = topo(j,i) + rovg*t(km,j,i) * &
                      log(psfc/((psfc-ptp)*sig(km)+ptp))
        do k = km - 1 , 1 , -1
          tbar = 0.5*(t(k,j,i)+t(k+1,j,i))
          htsig(k) = htsig(k+1) + rovg*tbar * &
             log(((psfc-ptp)*sig(k+1)+ptp)/((psfc-ptp)*sig(k)+ptp))
        end do
        kt = 1
        do k = 1 , km
          if ( psig(k) < p ) kt = k
        end do
        kb = kt + 1
        if ( p <= psig(1) ) then
          temp = t(1,j,i)
          hp(j,i) = htsig(1) + rovg*temp*log(psig(1)/p)
        else if ( (p > psig(1)) .and. (p < psig(km)) ) then
          wt = log(psig(kb)/p)/log(psig(kb)/psig(kt))
          wb = log(p/psig(kt))/log(psig(kb)/psig(kt))
          temp = wt*t(kt,j,i) + wb*t(kb,j,i)
          temp = (temp+t(kb,j,i))/2.0
          hp(j,i) = htsig(kb) + rovg*temp*log(psig(kb)/p)
        else if ( (p >= psig(km)) .and. (p <= psfc) ) then
          temp = t(km,j,i)
          hp(j,i) = topo(j,i) + rovg*temp*log(psfc/p)
        else if ( p > psfc ) then
          temp = t(kbc,j,i) + lrate*(htsig(kbc)-topo(j,i))
          hp(j,i) = topo(j,i) + &
                  (temp/lrate)*(1.0-exp(+rovg*lrate*log(p/psfc)))
        end if
      end do
    end do
  end subroutine height_nonhydro

end module mod_hgt
! vim: tabstop=8 expandtab shiftwidth=2 softtabstop=2