import notf.util.time_utils

def test_to_utc():
    # TODO: account for DST
    assert '0 12' == notf.util.time_utils.to_utc('8:00')
    assert '0 18' == notf.util.time_utils.to_utc('14:00')
    assert '15 20' == notf.util.time_utils.to_utc('16:15')
    assert '15 3' == notf.util.time_utils.to_utc('23:15')

