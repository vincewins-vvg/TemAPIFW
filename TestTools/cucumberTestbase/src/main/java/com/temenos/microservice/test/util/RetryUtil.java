package com.temenos.microservice.test.util;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collection;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.function.Supplier;


public class RetryUtil {

    private static final Logger log = LoggerFactory.getLogger(RetryUtil.class);

    public static <T> T getWithRetry(int timeoutSeconds, Supplier<T> supplier, String message) throws TimeoutException {
        long timeoutMillis = timeoutSeconds * 1000;
        long start = System.currentTimeMillis();
        try {
            return Executors.newSingleThreadExecutor()
                    .submit(() -> {
                        T value;
                        while ((value = getSafeFromSupplier(supplier)) == null && System.currentTimeMillis() - start < timeoutMillis) {
                            try {
                                log.info("Waiting 5 seconds before retrying with: {}", message);
                                Thread.sleep(5000);
                            } catch (InterruptedException e) {
                                throw new RuntimeException("Interrupted");
                            }
                        }
                        return value;
                    })
                    .get(timeoutSeconds, TimeUnit.SECONDS);
        } catch (TimeoutException e) {
            throw new TimeoutException("Timed out waiting to execute supplier " + supplier.toString());
        } catch (ExecutionException | InterruptedException e) {
            throw new RuntimeException("Error while executing supplier " + supplier, e);
        }
    }

    private static <T> T getSafeFromSupplier(Supplier<T> supplier) {
        try {
            T t = supplier.get();
            return (t instanceof Collection && ((Collection) t).isEmpty()) ? null : t;
        } catch (Exception e) {
            log.debug("Supplier failed with error message: {}", e.getMessage(), e);
            return null;
        }
    }
}
