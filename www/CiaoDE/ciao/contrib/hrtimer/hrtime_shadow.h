#ifndef _HRTIME_SHADOW_H_
#define _HRTIME_SHADOW_H_
# 1 "./include_hrtime.h"
# 1 "/usr/include/linux/hrtime.h" 1 3


 







# 1 "/usr/include/linux/config.h" 1 3



# 1 "/usr/include/linux/autoconf.h" 1 3
 




 




 






















 






 





































 





 





























































 































 




 





 




 







 




 









 






































 













 







 












 




 












 










 




 




 















 









 















 





 




 

























 











 









 






































 

























 

















































 




 



# 4 "/usr/include/linux/config.h" 2 3



# 11 "/usr/include/linux/hrtime.h" 2 3


# 1 "/usr/include/asm/spinlock.h" 1 3









 





  typedef struct { } spinlock_t;
  


















# 80 "/usr/include/asm/spinlock.h" 3


 












  typedef struct { } rwlock_t;
  























# 253 "/usr/include/asm/spinlock.h" 3


# 13 "/usr/include/linux/hrtime.h" 2 3

# 1 "/usr/include/asm/hrtime.h" 1 3


 







# 1 "/usr/include/asm/msr.h" 1 3
 





























# 11 "/usr/include/asm/hrtime.h" 2 3


typedef unsigned long long hrtime_t;

static inline void get_current_hrtime(volatile hrtime_t *t)
{
	volatile unsigned long *parts = (volatile unsigned long *) t;

	__asm__ __volatile__("rdtsc" : "=a" ( parts[0] ), "=d" (  parts[1] )) ;
	return;
}


# 14 "/usr/include/linux/hrtime.h" 2 3


 


 



struct hrtime_struct
{
	 
	 
	volatile hrtime_t last_us_dispatch;
	volatile hrtime_t utime;
	volatile hrtime_t stime;
	volatile long in_system;

	 



	long has_ustime;

	 
	hrtime_t start_time;

	 
	volatile hrtime_t last_dispatch;
	volatile hrtime_t vtime;

	volatile long     offset_to_cpu0;

	long              refcount;
	spinlock_t        reflock;
};

# 89 "/usr/include/linux/hrtime.h" 3



# 1 "./include_hrtime.h" 2

#endif /* _HRTIME_SHADOW_H_ */
