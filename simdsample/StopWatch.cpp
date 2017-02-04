//
//  StopWatch.cpp
//  cpp11lib
//
//  Created by pebble8888 on 2015/09/24.
//  Copyright (c) 2015年 pebble8888. All rights reserved.
//

#include "StopWatch.h"
#include <iostream>

StopWatch::StopWatch()
{
    start();
}
void StopWatch::start(void)
{
    start_ = std::chrono::system_clock::now();
}

void StopWatch::stop(void)
{
    auto end = std::chrono::system_clock::now();
    elapsed_microseconds_ = std::chrono::duration_cast<std::chrono::microseconds>(end - start_);
}

long StopWatch::microseconds(void)
{
    return static_cast<long>( elapsed_microseconds_.count() );
}

std::string StopWatch::description(void)
{
    return std::to_string(elapsed_microseconds_.count()) + " us";
}
