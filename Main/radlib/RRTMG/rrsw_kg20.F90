      module rrsw_kg20

      use parkind ,only : im => kind_im, rb => kind_rb
      use parrrsw, only : ng20

      implicit none
      save

!-----------------------------------------------------------------
! rrtmg_sw ORIGINAL abs. coefficients for interval 20
! band 20:  5150-6150 cm-1 (low - h2o; high - h2o)
!
! Initial version:  JJMorcrette, ECMWF, oct1999
! Revised: MJIacono, AER, jul2006
! Revised: MJIacono, AER, aug2008
! Revised: MJIacono, AER, nov2015, solar variability
!-----------------------------------------------------------------
!
!  name     type     purpose
!  ----   : ----   : ---------------------------------------------
! kao     : real
! kbo     : real
! selfrefo: real
! forrefo : real
!sfluxrefo: real
!irradnceo: real
!facbrghto: real
!snsptdrko: real
! absch4o : real
!-----------------------------------------------------------------

      integer(kind=im), parameter :: no20 = 16

      real(kind=rb) :: kao(5,13,no20)
      real(kind=rb) :: kbo(5,13:59,no20)
      real(kind=rb) :: selfrefo(10,no20), forrefo(4,no20)
      real(kind=rb) :: sfluxrefo(no20)
      real(kind=rb) :: irradnceo(no20)
      real(kind=rb) :: facbrghto(no20),snsptdrko(no20)
      real(kind=rb) :: absch4o(no20)

      real(kind=rb) :: rayl

!-----------------------------------------------------------------
! rrtmg_sw COMBINED abs. coefficients for interval 20
! band 20:  5150-6150 cm-1 (low - h2o; high - h2o)
!
! Initial version:  JJMorcrette, ECMWF, oct1999
! Revised: MJIacono, AER, jul2006
! Revised: MJIacono, AER, aug2008
! Revised: MJIacono, AER, nov2015, solar variability
!-----------------------------------------------------------------
!
!  name     type     purpose
!  ----   : ----   : ---------------------------------------------
! ka      : real
! kb      : real
! absa    : real
! absb    : real
! selfref : real
! forref  : real
! sfluxref: real
! irradnce: real
! facbrght: real
! snsptdrk: real
! absch4  : real
!-----------------------------------------------------------------

      real(kind=rb) :: ka(5,13,ng20), absa(65,ng20)
      real(kind=rb) :: kb(5,13:59,ng20), absb(235,ng20)
      real(kind=rb) :: selfref(10,ng20), forref(4,ng20)
      real(kind=rb) :: sfluxref(ng20)
      real(kind=rb) :: irradnce(ng20)
      real(kind=rb) :: facbrght(ng20),snsptdrk(ng20)
      real(kind=rb) :: absch4(ng20)

      equivalence (ka(1,1,1),absa(1,1)), (kb(1,13,1),absb(1,1))

      end module rrsw_kg20


! vim: tabstop=8 expandtab shiftwidth=2 softtabstop=2
