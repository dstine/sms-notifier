import datetime

import pytz

LOCAL_TZ = pytz.timezone('America/New_York')

def to_utc(h_local, m_local):
    now = datetime.datetime.now(tz=LOCAL_TZ)
    local = now.replace(hour=h_local, minute=m_local)
    utc = local.astimezone(pytz.utc)
    return f'{utc.minute} {utc.hour}'

