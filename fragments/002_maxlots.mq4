/**
 * getMaxLots : 現在注文可能なLot数を計算
 * 対円ペアかつ口座通貨が円/ドルのみ有効(USDJPY, EURJPY, GBPJPY...)
 **/

/**
 * @return maxlots {Double} 最大注文可能数
 **/
double getMaxLots() {

   double maxlots = 0;

   if (AccountCurrency() == "JPY") {
      maxlots = 0.1 * AccountLeverage() * (AccountBalance() / (10000*Ask));
   } else if (AccountCurrency() == "USD") {
      maxlots = 0.1 * AccountLeverage() * (AccountBalance() / 10000);
   } else {
      maxlots = 0;
   }

   return maxlots;
}
