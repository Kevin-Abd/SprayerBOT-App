#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject *parent = nullptr);
    ~FileIO();

public slots:
    bool write(const QString& data);
//    bool write(const QString& source, const QString& data);
    bool open(const QString& fileName);
    bool close();

private:
    QFile* file;
    QTextStream* fout;
    bool isOpen;

};

#endif // FILEIO_H
