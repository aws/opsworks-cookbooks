!/bin/sh

S3=/home/ubuntu/s3

#vnc�N��

/usr/bin/vncserver


#insync�̓����I���m�F
sleep 30
/usr/bin/insync resume_syncing
sleep 60
insync=`insync get_sync_progress`

while [ "$insync" != "No syncing activities" ]
              do
                            sleep 1
                            insync=`insync get_sync_progress`
              done

insync pause_syncing
#�o�b�N�A�b�v�̑O�ɓ�����~

#�o�b�N�A�b�v���쐬���A�������̊m�F���s��

cp -r $S3/Googledrive $S3/backup_`date +%Y-%m-%d`
#�o�b�N�A�b�v�t�@�C�����쐬

diff -r $S3/Googledrive $S3/backup_`date +%Y-%m-%d`

if [ $? != 0 ]
then
        ls -ltr $S3 | mail k-watanabe@enrise-corp.co.jp -s �g�o�b�N�A�b�v���s�h
    #�o�b�N�A�b�v�̎��s
else
        ls -ltr $S3 | mail k-watanabe@enrise-corp.co.jp -s �g�o�b�N�A�b�v�����h
    #�o�b�N�A�b�v�̐���



#�Â�����̃o�b�N�A�b�v���폜

find $S3 -type d -mtime +6 -name "backup_20*" | xargs rm -fr
#7���ȑO�ɍ쐬�����t�@�C�����m�F��A�폜������B
fi

#�S�~���̍폜
rm -fr /home/ubuntu/S3/Googledrive/.insync-trash

sudo /sbin/shutdown -h now