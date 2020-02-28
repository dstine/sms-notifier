import datetime

import pytz

LOCAL_TZ = pytz.timezone('America/New_York')

def to_utc(hh_mm_local):
    h_local, m_local = hh_mm_local.split(':')
    now = datetime.datetime.now(tz=LOCAL_TZ)
    local = now.replace(hour=int(h_local), minute=int(m_local))
    utc = local.astimezone(pytz.utc)
    return f'{utc.minute} {utc.hour}'

