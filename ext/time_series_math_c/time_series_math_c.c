#include <ruby.h>

// Returns timestamp at index +i+.
//
static double timestamp_at_i(VALUE rb_data_array, int i ) {
    VALUE m_elem;

    m_elem = rb_ary_entry(rb_data_array, i);
    return NUM2DBL( rb_ary_entry(m_elem, 0) );
}

// Returns indices of elements surrounding timestamp +t+.
// The pair of indices is found using binary search over sorted @data array.
//
// Ruby equivalent:
//
// def indices_at(t)
//   return [nil, nil] if size == 0
//   return [nil, 0] if t < t_first
//   return [size - 1, nil] if t >= t_last
//   ileft = 0
//   iright = size - 1
//   while iright - ileft > 1
//     icenter = ileft + (iright - ileft) / 2
//     if t >= data[icenter][0]
//       ileft = icenter
//     else
//       iright = icenter
//     end
//   end
//   [ileft, iright]
// end
//
static VALUE time_series_bsearch_indices_at(VALUE rb_self, VALUE rb_t) {
    VALUE m_data;
    int _size;
    double _t;
    int _ileft, _iright, _icenter;

    m_data = rb_iv_get(rb_self, "@data");
    _size = RARRAY_LEN(m_data);
    _t = NUM2DBL(rb_t);

    // initial conditions check:
    if ( _size == 0 ) {
        return rb_ary_new3( 2, Qnil, Qnil );
    }
    if ( _t < timestamp_at_i( m_data, 0 ) ) {
        return rb_ary_new3( 2, Qnil, INT2FIX(0) );
    }
    if ( _t >= timestamp_at_i( m_data, _size-1 ) ) {
        return rb_ary_new3( 2, INT2FIX(_size-1), Qnil );
    }

    // find left & right indices using binary search:
    _ileft = 0;
    _iright = _size - 1;
    while ( _iright - _ileft > 1 ) {
        _icenter = _ileft + ( _iright - _ileft ) / 2;
        if ( _t >= timestamp_at_i( m_data, _icenter) ) {
            _ileft = _icenter;
        } else {
            _iright = _icenter;
        }
    }
    return rb_ary_new3( 2, INT2FIX(_ileft), INT2FIX(_iright) );
}

void Init_time_series_math_c() {
    // get TimeSeriesMath module
    ID sym_TimeSeriesMath = rb_intern("TimeSeriesMath");
    VALUE mTimeSeriesMath = rb_const_get(rb_cObject, sym_TimeSeriesMath);

    // get TimeSeriesMath::TimeSeries class
    ID sym_TimeSeries = rb_intern("TimeSeries");
    VALUE kTimeSeries = rb_const_get(mTimeSeriesMath, sym_TimeSeries);

    // define TimeSeriesMath::TimeSeries#bsearch_indices_at
    rb_define_method(kTimeSeries, "bsearch_indices_at", time_series_bsearch_indices_at, 1);
}
