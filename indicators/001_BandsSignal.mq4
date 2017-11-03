#property  indicator_chart_window
#property  indicator_buffers 5
#property  indicator_color1  Yellow
#property  indicator_color2  Red
#property  indicator_color3  Orange
#property  indicator_color4  Orange
#property  indicator_color5  Orange

input double ma_tilt_threshold = 0;
input int bands_period = 20;
input bool draw_line = true;
input bool alert = false;
input bool mail = false;

double UpArrow[];
double DnArrow[];
double upper[];
double lower[];
double main[];

int minute = 0;
bool sentMail = false;

int OnInit() {
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, UpArrow);

   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, DnArrow);

   if (draw_line) {
      SetIndexStyle(2, DRAW_LINE, EMPTY, 2);
      SetIndexBuffer(2, upper);

      SetIndexStyle(3, DRAW_LINE, EMPTY, 2);
      SetIndexBuffer(3, lower);

      SetIndexStyle(4, DRAW_LINE, EMPTY, 1);
      SetIndexBuffer(4, main);
   }

   return INIT_SUCCEEDED;
}

int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[])
{
   int limit = rates_total - prev_calculated;
   for(int i=0; i<limit; i++)
   {
      double _upper = iBands(NULL, 0, bands_period, 2, 0, PRICE_CLOSE, MODE_UPPER, i);
      double _lower = iBands(NULL, 0, bands_period, 2, 0, PRICE_CLOSE, MODE_LOWER, i);
      double maTilt = iMA(NULL, 0, bands_period*5, 0, MODE_SMA, PRICE_CLOSE, i)-iMA(NULL, 0, bands_period*5, 0, MODE_SMA, PRICE_CLOSE, i+1);

      upper[i] = _upper;
      lower[i] = _lower;
      main[i] = iMA(NULL, 0, bands_period*5, 0, MODE_SMA, PRICE_CLOSE, i);

      if (
         maTilt > ma_tilt_threshold &&
         Low[i] < _lower
      ) {
         UpArrow[i] = Low[i] - 20*Point;
      } else {
         UpArrow[i] = EMPTY_VALUE;
      }

      if (
         maTilt < -ma_tilt_threshold &&
         High[i] > _upper
      ) {
         DnArrow[i] = High[i] + 20*Point;
      } else {
         DnArrow[i] = EMPTY_VALUE;
      }

   }

   if (
      (UpArrow[0] != EMPTY_VALUE || DnArrow[0] != EMPTY_VALUE) &&
      Minute() != minute
   ) {
      ringAlert();
      sendEmail();
      minute = Minute();
   }

   return(rates_total-1);
}

void ringAlert() {
   if (alert) {
      PlaySound("alert.wav");
   }
}

void sendEmail() {
   if (mail && !sentMail) {
      string title = "";
      string content = "";
      if (UpArrow[0] !=EMPTY_VALUE) {
         title = Symbol()+" : Signal Buy";
         content = Symbol()+" : Signal Buy at "+Bid;
      } else {
         title = Symbol()+" : Signal Sell";
         content = Symbol()+" : Signal Sell at "+Bid;
      }
      SendMail(title, content);
      sentMail = true;
   }
}
