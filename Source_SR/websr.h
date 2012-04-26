/*
 *  websr.h
 *  TWI_Master
 *
 *  Created by Sysadmin on 10.02.08.
 *  Copyright 2008 Ruedi Heimlicher. All rights reserved.
 *
 */
#ifndef _WEBSR_H
#define _WEBSR_H

#include <inttypes.h>



void websr_set_mode(uint8_t derMode);
void websr_load_byte(uint8_t out_byte0, uint8_t out_byte1);

uint8_t ready_for_send(void);
uint8_t websr_shift_byte_out(uint8_t out_byte);
void websr_pulse(uint8_t delay);
void websr_pulse_ms(uint8_t delay);
uint8_t websr_shift_byte_in(void);
uint8_t  ListenForRequest(void);
void websr_sr_out(void);

void websr_sr_in(void);

uint8_t websr_twi_check(void);
void websr_shift_SR_bytes_in(uint8_t* inData0, uint8_t* inData1);
void websr_load_SR_bytes(uint8_t out_byte0, uint8_t out_byte1);
void  iow_shift_SR_bytes_out(uint8_t out_byte0, uint8_t out_byte1);
void websr_reset(void);
#endif
