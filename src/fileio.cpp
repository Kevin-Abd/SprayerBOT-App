#include "fileio.h"

FileIO::FileIO(QObject *parent) : QObject(parent)
{
    isOpen = false;
}

FileIO::~FileIO()
{
    close();
}

bool FileIO::open(const QString& fileName)
{
//    qDebug("FileIO open");
//    qDebug(fileName.toStdString().c_str());
    if (fileName.isEmpty())
        return false;

    file = new QFile(fileName);
    isOpen = file->open(QFile::Append);
//    qDebug(isOpen ? "Open" : "NotOpen");
    if(isOpen)
        fout = new QTextStream(file);
    else
        qErrnoWarning("FileIO Open failed");

    return isOpen;
}

bool FileIO::close()
{
    if (isOpen)
    {
        file->close();
        isOpen = false;
        return true;
    }
    else
        return false;

}

bool FileIO::write(const QString& data)
{
    if (!isOpen)
        return false;

    *fout << data;
    fout->flush();

    return true;
}
