#include <fstream>

//#define DEBUG
#ifdef DEBUG
#define DEBUG_OUTPUT(x)              \
    do {                             \
        std::cout << x << std::endl; \
    } while (0)
#else
#define DEBUG_OUTPUT(x)
#endif

class File {
   public:
    File(std::ifstream &&stream) : mFile(std::move(stream)) {}

    // Move the cursor 1 byte forward. It will automatially read the file
    //  into the buffer when needed.
    // Return true when succeed; return false if the EOF has been reached.
    bool next() noexcept {
        if (mBufferPosition < mValidBufferSize - 1)
            mBufferPosition++;
        else {
            if (mFile.eof()) return false;
            mFile.clear();
            mFile.read(mBuffer, BufferSize);
            mValidBufferSize = mFile.gcount();
            DEBUG_OUTPUT("Reading files to buffer, new valid buffer size: "<< mValidBufferSize);
            if (mValidBufferSize == 0)
                return false;
            mBufferPosition = 0;
        }
        if (get() == '\n') { mLine++; mColumn=0; }
        else mColumn++;
        return true;
    }
    
    // Will the next next() return false?
    bool willEOF() noexcept {
        return mBufferPosition >= mValidBufferSize - 1 && (mFile.eof() || mFile.peek() == EOF);
    }
    
    // Read the remaining file and return if there is any \n.
    bool newLineInRemainingFile(bool includingNow) noexcept {
        if (get() == '\n' && includingNow) return true;
        while (next()) {
            DEBUG_OUTPUT("In newLineInRemainingFile:while, get()="<<get()<<":"<<int(get()));
            if (get() == '\n') return true;
        }
        return false;
    }

    // Read the remaining file and return if there is any non-space character.
    // Note that this function will consume the remaining file.
    bool charactersInRemainingFile(bool includingNow) noexcept {
        if(includingNow && get() != ' ' && get() != '\r' && get() != '\0' && get() != '\n')
            return true;
        while (next()) {
            DEBUG_OUTPUT("In charactersInRemainingFile, get()="<<get()<<":"<<int(get()));
            if (get() != ' ' && get() != '\r' && get() != '\0' && get() != '\n')
                return true;
        }
        return false;
    }

    // Read the remaining file and return if there is any non-space character.
    // Note that this function will consume the remaining line.
    bool charactersInRemainingLine(bool includingNow) noexcept {
        if(willEOF()) return includingNow?(get()!=' '&&get()!='\r'&&get()!='\n'&&get()!='\0'):false;
        if(!includingNow) if (!next()) return false;
        while (get() != '\n') {
            DEBUG_OUTPUT("In charactersInRemainingLine, get()="<<get()<<":"<<int(get()));
            if (get()!=' '&&get()!='\r'&&get()!='\0') return true;
            if (!next()) break;
        }
        return false;
    }

    char get() const noexcept { return mBuffer[mBufferPosition]; }
    unsigned long long getLine() const noexcept { return mLine; }
    unsigned long long getColumn() const noexcept { return mColumn; }
    std::streamsize getBufferPosition() const noexcept { return mBufferPosition; }

    void _dbg() const noexcept {
        DEBUG_OUTPUT("line " << mLine << ", column " << mColumn
                             << ", bufferpos " << mBufferPosition
                             << "/" << mValidBufferSize
                             << " eof?:" << mFile.eof()
                             << " char:" << (get()=='\n'?'*':get())
                             << ":" << int(get()));
    }

   private:
    static constexpr size_t BufferSize = 1024 * 1024;  // 1MB
    unsigned long long mLine = 1;
    unsigned long long mColumn = 0;
    std::streamsize mBufferPosition = 0;
    std::streamsize mValidBufferSize = 0;
    std::ifstream mFile;
    char mBuffer[BufferSize];
};
