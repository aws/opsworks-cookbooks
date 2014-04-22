!/bin/sh

S3=/home/ubuntu/s3

#vnc起動

/usr/bin/vncserver


#insyncの同期終了確認
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
#バックアップの前に同期停止

#バックアップを作成し、整合性の確認を行う

cp -r $S3/Googledrive $S3/backup_`date +%Y-%m-%d`
#バックアップファイルを作成

diff -r $S3/Googledrive $S3/backup_`date +%Y-%m-%d`

if [ $? != 0 ]
then
        ls -ltr $S3 | mail k-watanabe@enrise-corp.co.jp -s “バックアップ失敗”
    #バックアップの失敗
else
        ls -ltr $S3 | mail k-watanabe@enrise-corp.co.jp -s “バックアップ成功”
    #バックアップの成功



#古い世代のバックアップを削除

find $S3 -type d -mtime +6 -name "backup_20*" | xargs rm -fr
#7日以前に作成したファイルを確認後、削除をする。
fi

#ゴミ箱の削除
rm -fr /home/ubuntu/S3/Googledrive/.insync-trash

sudo /sbin/shutdown -h now