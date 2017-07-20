#!/usr/bin/python
import socket,asyncore
import time
import random
import os
import sys

NOW=0
CNT=-1

class receiver(asyncore.dispatcher):
    def __init__(self,conn):
        asyncore.dispatcher.__init__(self,conn)
        self.from_remote_buffer=''
        self.to_remote_buffer=''
        self.sender=None

    def handle_connect(self):
        pass

    def handle_read(self):
        read = self.recv(4096)
        #print '%04i -->'%len(read)
        self.from_remote_buffer += read

    def writable(self):
        return (len(self.to_remote_buffer) > 0)

    def handle_write(self):
        sent = self.send(self.to_remote_buffer)
        #print 'reciver.%04i <--'%sent
        self.to_remote_buffer = self.to_remote_buffer[sent:]

    def handle_close(self):
        global NOW
        global CNT
        NOW=time.time() # update accept time
        try:
            if not self.to_remote_buffer and not self.from_remote_buffer:
                self.close()
                if self.sender:
                    self.sender.close()
        except Exception as e:
                print e
        #check connect times
        CNT=CNT-1
        if CNT == 0:
	        sys.exit(0)
        if CNT < 0:
            CNT=0

class sender(asyncore.dispatcher):
    def __init__(self, receiver, remoteaddr,remoteport):
        asyncore.dispatcher.__init__(self)
        self.receiver=receiver
        receiver.sender=self
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.connect((remoteaddr, remoteport))

    def handle_connect(self):
        pass

    def handle_read(self):
        read = self.recv(4096)
        #print 'sender.<-- %04i'%len(read)
        self.receiver.to_remote_buffer += read

    def writable(self):
        return (len(self.receiver.from_remote_buffer) > 0)

    def handle_write(self):
        sent = self.send(self.receiver.from_remote_buffer)
        #print '--> %04i'%sent
        self.receiver.from_remote_buffer = self.receiver.from_remote_buffer[sent:]

    def handle_close(self):
        global NOW
        NOW=time.time() # update accept time
        try:
            if not self.receiver.to_remote_buffer and not self.receiver.from_remote_buffer:
                self.close()
                #import pdb;pdb.set_trace()
                self.receiver.close()
        except Exception as e:
            print e

class forwarder(asyncore.dispatcher):
    def __init__(self, ip,source_ip,remoteip,remoteport,backlog=1):
        asyncore.dispatcher.__init__(self)
        self.remoteip=remoteip
        self.remoteport=remoteport
        self.source_ip=source_ip
        self.create_socket(socket.AF_INET,socket.SOCK_STREAM)
        self.set_reuse_addr()
        #self.bind((ip,8080))
        self.bind_port_get_available_port(ip)
        self.listen(backlog)

    def handle_accept(self):
        global NOW
        NOW=time.time() # update accept time
        conn, addr = self.accept()
        #if self.source_ip==addr[0]:
        #    print self.source_ip,addr
        sender(receiver(conn),self.remoteip,self.remoteport)
    def bind_port_get_available_port(self,ip):
        while True:
            port=random.randint(50000,60000)
            try:   
                self.bind((ip,port))
                self.port=port
                break
            except socket.error:
                #print port,'used'
                continue 


def actionloop():
    while True:
        asyncore.loop(timeout=1, use_poll=False, count=1)
        n=time.time()-NOW
        if n>options.timeout:
          
            if len(asyncore.socket_map)<=1:
                break

if __name__=='__main__':
    import optparse
    parser = optparse.OptionParser()

    parser.add_option(
        '-l','--local-ip',
        dest='local_ip',default='127.0.0.1',
        help='Local IP address to bind to')
    parser.add_option(
        '-s','--source_ip',
        dest='source_ip',default='127.0.0.1',
        help='client ip to connect')
    parser.add_option(
        '-r','--remote-ip',dest='remote_ip',
        help='Local IP address to bind to')
    parser.add_option(
        '-P','--remote-port',
        type='int',dest='remote_port',default=80,
        help='Remote port to bind to')
    parser.add_option(
        '-t','--timeout',
        type='int',dest='timeout',default=60,
        help='set time out')
    parser.add_option(
        '-c','--count',
        type='int',dest='count',default=100,
        help='set connect times')
    parser.add_option("-d",'--deamon', action="store_true", dest="deamon", help='set deamon process')
    options, args = parser.parse_args()
    NOW=time.time() # update accept time
    CNT=options.count
    forward_obj1=forwarder(options.local_ip,options.source_ip,options.remote_ip,options.remote_port)
    forward_obj2=forwarder('192.168.86.200','192.168.86.1','192.168.87.12',7578)
    print forward_obj1.port,80
    print forward_obj2.port,7578
    print options.deamon
    #if options.deamon==True :
    #    child_pid = os.fork()  
    #    if child_pid == 0:  
    #        actionloop()
    #else:
    actionloop()
