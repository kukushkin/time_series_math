#include <ruby.h>

static VALUE time_series_bsearch_test(VALUE rb_self) {
    printf("Hello from TimeSeries C extension\n");
    return Qnil;
}

void Init_time_series_math_c() {
    // get TimeSeriesMath module
    ID sym_TimeSeriesMath = rb_intern("TimeSeriesMath");
    VALUE mTimeSeriesMath = rb_const_get(rb_cObject, sym_TimeSeriesMath);

    // get TimeSeriesMath::TimeSeries class
    ID sym_TimeSeries = rb_intern("TimeSeries");
    VALUE kTimeSeries = rb_const_get(mTimeSeriesMath, sym_TimeSeries);

    // define TimeSeriesMath::TimeSeries#bsearch_test
    rb_define_method(kTimeSeries, "bsearch_test", time_series_bsearch_test, 0);
}
