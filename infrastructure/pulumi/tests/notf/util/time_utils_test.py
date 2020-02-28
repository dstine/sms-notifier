import notf.util.time_utils

def test_to_utc():
    assert '0 13' == notf.util.time_utils.to_utc('8:00')
    assert '0 19' == notf.util.time_utils.to_utc('14:00')
    assert '15 21' == notf.util.time_utils.to_utc('16:15')
    assert '15 4' == notf.util.time_utils.to_utc('23:15')

