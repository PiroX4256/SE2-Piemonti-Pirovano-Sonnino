package it.polimi.se2.clupapplication.utils;

import java.util.Calendar;
import java.util.Date;

public class DateComparison {

    public static boolean compareDates(Date date1, Date date2) {
        Calendar calendar1 = Calendar.getInstance(), calendar2 = Calendar.getInstance();
        calendar1.setTime(date1);
        calendar1.set(Calendar.HOUR_OF_DAY, 0);
        calendar1.set(Calendar.MINUTE, 0);
        calendar1.set(Calendar.SECOND, 0);
        calendar1.set(Calendar.MILLISECOND, 0);
        calendar2.setTime(date2);
        calendar2.set(Calendar.HOUR_OF_DAY, 0);
        calendar2.set(Calendar.MINUTE, 0);
        calendar2.set(Calendar.SECOND, 0);
        calendar2.set(Calendar.MILLISECOND, 0);
        return calendar1.getTimeInMillis() == calendar2.getTimeInMillis();
    }
}
