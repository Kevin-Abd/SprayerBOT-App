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
    bool open(const QString& dir, const QString& fileName);
    bool close();

    bool write(const QString& data);

private:
    QFile* file;
    QTextStream* fout;
    bool isOpen;

};

#endif // FILEIO_H
